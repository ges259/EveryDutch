//
//  UIView+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit
import SnapKit

// MARK: - UIView

extension UIView {
    
    // MARK: - 뷰 만들기 +배경 색
    static func configureView(
        color: UIColor
    ) -> UIView {
        let view = UIView()
            view.backgroundColor = color
        
        return view
    }
    
    // MARK: - 모서리 설정
    /// 모서리 둥글게 처리 설정
    func setRoundedCorners(_ type: CornerRoundType,
                           withCornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = type.cornerMask
        // .none이라면 false
        // .none이 아니라면 true
        self.clipsToBounds = type != .none
    }
    
    // MARK: - 그림자 추가
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
    // MARK: - AttributedText
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




// MARK: - 색상 피커
extension UIView {
    /// UIView의 현재 그림자 속성을 가져오는 계산 속성
    var dropShadowProperties: ShadowProperties? {
        guard let shadowColor = self.layer.shadowColor else { return nil }
        return ShadowProperties(
            color: shadowColor,
            opacity: self.layer.shadowOpacity,
            offset: self.layer.shadowOffset,
            radius: self.layer.shadowRadius)
    }
    
    /// 특정한 그림자 속성을 UIView에 적용하는 메서드
    func applyDropShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    /// ShadowProperties 구조체를 받아서 해당하는 그림자 속성을 UIView에 적용하는 메서드
    func applyDropShadow(_ properties: ShadowProperties) {
        applyDropShadow(color: UIColor(cgColor: properties.color), opacity: properties.opacity, offset: properties.offset, radius: properties.radius)
    }
    
    /// UIView에서 그림자를 제거하는 메서드
    func removeDropShadow() {
        self.layer.shadowColor = nil
        self.layer.shadowOpacity = 0
    }
    
    /// UIView의 레이아웃을 즉시 업데이트하는 메서드
    func layoutNow() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
