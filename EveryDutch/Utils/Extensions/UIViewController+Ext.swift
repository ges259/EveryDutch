//
//  UIViewController+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import UIKit

extension UIViewController {
    /// 커스텀 얼럿창을 생성하고 표시하는 메서드
    @MainActor
    func customAlert(
        alertStyle: UIAlertController.Style = .alert,
        alertEnum: AlertEnum,
        buttonColors: [UIColor] = [UIColor.black],
        completion: @escaping (Int) -> Void)
    {
        // UIAlertController 인스턴스를 생성
        let alertController = UIAlertController(
            title: alertEnum.title,
            message: alertEnum.message,
            preferredStyle: alertStyle)
        
        // 각 버튼에 대한 액션을 추가
        for (index, buttonTitle) in alertEnum.buttons.enumerated() {
            // 버튼 색상을 설정합니다. 색상 배열의 범위를 초과하지 않도록 설정
            let color = index < buttonColors.count
            ? buttonColors[index]
            : UIColor.black
            // UIAlertAction을 생성하고 클릭 이벤트 핸들러를 추가
            let action = UIAlertAction(
                title: buttonTitle,
                style: .default) { _ in completion(index) }
            
            action.setValue(color, forKey: "titleTextColor")
            
            alertController.addAction(action)
        }
        
        // 취소 버튼 설정
        if alertEnum.cancelBtn {
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(cancel)
        }
        
        // 얼럿창을 화면에 표시
        self.present(alertController, animated: true)
    }
}
