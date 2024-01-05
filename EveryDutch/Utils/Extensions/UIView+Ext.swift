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
}


// UIView 확장하여 그림자 추가 함수 구현
extension UIView {
    // 그림자를 추가하는 함수
    func addShadow(top: Bool,
                   bottom: Bool,
                   shadowColor: UIColor = .black,
                   shadowOpacity: Float = 0.1,
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
        }
        
        // 하단 그림자 설정
        if bottom {
            layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
        }
    }
}
