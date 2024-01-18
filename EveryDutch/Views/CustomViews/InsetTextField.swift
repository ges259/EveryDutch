//
//  InsetTextField.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

class InsetTextField: UITextField {
    var insetX: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    var insetY: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    
    init(backgroundColor: UIColor,
         placeholerColor: UIColor = UIColor.placeholder_gray,
         placeholderText: String? = nil,
         insetX: CGFloat = 16) {
        super.init(frame: .zero)
        
        self.font = UIFont.systemFont(ofSize: 13)
        self.backgroundColor = backgroundColor
        self.insetX = insetX
        
        if let placeholderText = placeholderText {
            self.attributedPlaceholder = self.setAttributedText(
                placeholderText: placeholderText,
                placeholerColor: placeholerColor)
        }
    }
    convenience init(placeholderText: String,
                     keyboardType: UIKeyboardType,
                     keyboardReturnType: UIReturnKeyType,
                     insertX: CGFloat = 16) {
        self.init(backgroundColor: UIColor.normal_white,
                   placeholerColor: UIColor.placeholder_gray,
                   placeholderText: placeholderText,
                   insetX: insertX)
        self.keyboardType = keyboardType
        self.returnKeyType = keyboardReturnType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // insetX와 insetY의 값에 따라서 텍스트영역을 조절하도록 바꿀 것
        // -> textRect를 오버리이드
            // textRect: textField의 텍스트 영역을 지정해주는 함수
            // + 추가설명: 입력 중이 아닌 resignFirstResponder 상태일 경우의 입력된 위치
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // 원래 영역보다 insetX, insetY만큼 값이 작아지게 됨
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // 입력중의 텍스트 위치 설정
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // placeholderRect(bounds:) => 플레이스홀더의 위치 설정
}
