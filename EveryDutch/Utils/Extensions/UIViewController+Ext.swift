//
//  UIViewController+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import UIKit


enum AlertEnum {
    case loginFail
    case logout
    case timeFormat
    
    var title: String {
        switch self {
        case .loginFail: 
            return "로그인에 실패하였습니다. 다시 시도해 주세요."
        case .logout:
            return ""
        case .timeFormat:
            return "시간 형식을 선택해주세요"
        }
    }
    
    var message: String {
        switch self {
        case .loginFail: return ""
        case .logout: return ""
        case .timeFormat: return ""
        }
    }
    
    var buttons: [String] {
        switch self {
        case .loginFail: return ["확인"]
        default: return ["확인"]
        }
    }
    
}

extension UIViewController {
    /// 커스텀 얼럿창을 생성하고 표시하는 메서드
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
        // 얼럿창을 화면에 표시
        self.present(alertController, animated: true)
    }
}
