//
//  UIView+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


enum ShadowType {
    case all
    case top
    case bottom
    case card
}

extension UIView {
    static func configureView(color: UIColor) -> UIView {
        let view = UIView()
            view.backgroundColor = color
        return view
    }
    
    
    // 그림자를 추가하는 함수
    func addShadow(shadowType: ShadowType,
                   shadowColor: UIColor = .black,
                   shadowOpacity: Float = 0.15,
                   shadowOffset: CGSize = .zero,
                   shadowRadius: CGFloat = 5) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        switch shadowType {
        case .all:
            self.layer.shadowOffset = CGSize(width: 0, height: -shadowRadius)
            self.layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
            // 상단 그림자 설정
        case .top:
            self.layer.shadowOffset = CGSize(width: 0, height: -shadowRadius)
            // 하단 그림자 설정
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
        case .card:
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /// 모서리 둥글게 처리 설정
    func setRoundedCorners(_ type: CornerRoundType,
                           withCornerRadius radius: CGFloat) {
        self.layer.cornerRadius = type == .none ? 0 : radius
        self.layer.maskedCorners = type.cornerMask
        self.clipsToBounds = true
    }
}







enum CornerRoundType {
    case top
    case bottom
    case all
    case none
    
    var cornerMask: CACornerMask {
        switch self {
        case .top:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .all:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .none:
            return []
        }
    }
}
