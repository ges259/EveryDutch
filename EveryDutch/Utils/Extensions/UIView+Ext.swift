//
//  UIView+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

extension UIView {
    static func configureView(color: UIColor) -> UIView {
        let view = UIView()
            view.backgroundColor = color
        return view
    }
    
    
    // 그림자를 추가하는 함수
    func addShadow(top: Bool = false,
                   bottom: Bool = false,
                   card: Bool = false,
                   shadowColor: UIColor = .black,
                   shadowOpacity: Float = 0.15,
                   shadowOffset: CGSize = .zero,
                   shadowRadius: CGFloat = 5) {
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        
        

        // 상단 그림자 설정
        if top {
            layer.shadowOffset = CGSize(width: 0, height: -shadowRadius)
            // 하단 그림자 설정
        } else if bottom {
            layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
        } else if card {
            
            // 그림자의 위치를 지정합니다. 이 경우 우하단으로 5포인트 씩 떨어진 위치에 그림자가 생깁니다.
            self.layer.shadowOffset = CGSize(
                width: shadowRadius,
                height: shadowRadius)
        }
    }
    
    func setAttributedText(
        placeholderText: String,
        placeholerColor: UIColor = UIColor.placeholder_gray)
    -> NSAttributedString {
        let string = NSAttributedString.configure(
            text: placeholderText,
            color: placeholerColor,
            font: UIFont.systemFont(ofSize: 12))
        
        return string
    }
}
