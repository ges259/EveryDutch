//
//  UIViewController+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    /// 커스텀 얼럿창을 생성하고 표시하는 메서드
    func customAlert(
        alertStyle: UIAlertController.Style = .alert,
        alertEnum: AlertEnum,
        completion: @escaping (Int) -> Void)
    {
        // UIAlertController 인스턴스를 생성
        let alertController = UIAlertController(
            title: alertEnum.title,
            message: alertEnum.messageText,
            preferredStyle: alertStyle)
        
        // 각 버튼에 대한 액션을 추가
        for (index, buttonTitle) in alertEnum.doneButtonsTitle.enumerated() {
            // UIAlertAction을 생성하고 클릭 이벤트 핸들러를 추가
            let actionBtn = UIAlertAction(
                title: buttonTitle,
                style: .default) { _ in completion(index) }
            
            actionBtn.setValue(UIColor.black, forKey: "titleTextColor")
            
            alertController.addAction(actionBtn)
        }
        
        
        // 취소 버튼 설정
        if alertEnum.cancelBtnIsExist {
            let cancelBtn = UIAlertAction(title: "취소", style: .cancel)
            cancelBtn.setValue(UIColor.black, forKey: "titleTextColor") // 취소 버튼 색상 설정
            alertController.addAction(cancelBtn)
        }
        
        // 메인 스레드에서 present
        DispatchQueue.main.async {
            // 얼럿창을 화면에 표시
            self.present(alertController, animated: true)
        }
    }
    
    
    
    func cardHeight() -> CGFloat {
        return (self.view.frame.width - 20) * 1.8 / 3
    }
}











extension UIViewController {
    // MARK: - 로딩뷰
    
    private static var _hud: JGProgressHUD?
    
    var hud: JGProgressHUD {
        if let hud = UIViewController._hud {
            return hud
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.interactionType = .blockAllTouches
            UIViewController._hud = hud
            return hud
        }
    }
    
    private func showHUD() {
        DispatchQueue.main.async {
            if !self.hud.isVisible {
                self.hud.show(in: self.view, animated: true)
//                self.view.isUserInteractionEnabled = false
            }
        }
    }
    
    private func hideHUD() {
        DispatchQueue.main.async {
            if self.hud.isVisible {
                self.hud.dismiss(animated: true)
//                self.view.isUserInteractionEnabled = true
                print(#function)
            }
        }
    }
    
    /// 테이블뷰 / 콜렉션뷰의 리로드를 기다리는 동안 -> 화면을 터치 못하도록 설정
    func showLoading(_ show: Bool) {
        if show {
            self.showHUD()
        } else {
            self.hideHUD()
        }
    }
}

/// 탭바를 사용할 수 없게 / 있게 만드는 메서드
//    private func tabBarIsEnabled(_ isEnabled: Bool) {
//        let tabBarItemsArray = self.tabBarController?.tabBar.items
//        tabBarItemsArray?.forEach({ item in
//            item.isEnabled = isEnabled
//        })
//    }
