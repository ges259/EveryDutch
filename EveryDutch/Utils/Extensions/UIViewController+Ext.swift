//
//  UIViewController+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import UIKit

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
}
