//
//  CommonEditScreenType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - 공통 함수
extension EditScreenType {
    
    // MARK: - 바텀 버튼 타이틀
    func bottomBtnTitle(isMake: Bool) -> String? {
        return isMake
        ? "수정 완료"
        : "생성 완료"
    }
    
    // MARK: - 데코 관련 코드
    var cardHeaderTitle: String {
        return "카드 효과 설정"
    }
    var imageHeaderTitle: String {
        return "이미지 설정"
    }
}









































import UIKit

// MARK: - Extension
extension UIColor {
    
    /// 지정된 밝기 성분을 가진 색상을 반환
    func withBrightness(_ value: CGFloat) -> UIColor {
        // 색조
        var hue: CGFloat = 0
        // 채도
        var saturation: CGFloat = 0
        // alpha값
        var alpha: CGFloat = 0
        // 받은 밝기(brightness) 값이 0과 1 사이에 있도록 제한
        let brightness = max(0, min(value, 1))
        // 색상의 색조, 채도,. alpha값을 가져오기
        self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        // 색상 리턴
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// 색상의 밝기 성분 값
    var brightness: CGFloat {
        var brightness: CGFloat = 0
        self.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
    
    /// 색상의 명도를 반환
    var lightness: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        // 현재 색상의 빨강(red), 초록(green), 파랑(blue) 값을 가져오기
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        // 가져온 RGB값을 사용하여, 명도(lightness)를 가져오기
        return ((red * 299) + (green * 587) + (blue * 114)) / 1000
    }
    
    /// 색상이 대비 측면에서 '밝다'로 간주되는지 여부를 반환
    var isLight: Bool {
        // 계산된 명도가 0.5이상이면 true(밝음 표시)
        return lightness >= 0.5
    }
}

extension UIView {
    /// UIView의 현재 그림자 속성을 가져오는 계산 속성
    var dropShadowProperties: ShadowProperties? {
        guard let shadowColor = layer.shadowColor else { return nil }
        return ShadowProperties(color: shadowColor, opacity: layer.shadowOpacity, offset: layer.shadowOffset, radius: layer.shadowRadius)
    }
    
    /// 특정한 그림자 속성을 UIView에 적용하는 메서드
    func applyDropShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    /// ShadowProperties 구조체를 받아서 해당하는 그림자 속성을 UIView에 적용하는 메서드
    func applyDropShadow(_ properties: ShadowProperties) {
        applyDropShadow(color: UIColor(cgColor: properties.color), opacity: properties.opacity, offset: properties.offset, radius: properties.radius)
    }
    
    /// UIView에서 그림자를 제거하는 메서드
    func removeDropShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
    }
    
    /// UIView의 레이아웃을 즉시 업데이트하는 메서드
    func layoutNow() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
// MARK: - Struct


/// 그림자 속성을 정의하는 구조체
struct ShadowProperties {
    internal let color: CGColor
    internal let opacity: Float
    internal let offset: CGSize
    internal let radius: CGFloat
}

// MARK: - Protocol

// ChromaControlStylable 프로토콜
protocol ChromaControlStylable {
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
    var showsShadow: Bool { get set }
    
    func updateShadowIfNeeded()
}
// ChromaControlStylable 프로토콜을 채택하는 UIView 확장
extension ChromaControlStylable where Self: UIView {
    func shadowProperties(forHeight height: CGFloat) -> ShadowProperties {
        let dropShadowHeight = height * 0.01
        return ShadowProperties(color: UIColor.black.cgColor, opacity: 0.35, offset: CGSize(width: 0, height: dropShadowHeight), radius: 4)
    }
}
// MARK: - Delegate
protocol ChromaColorPickerDelegate: AnyObject {
    /// 뷰의 높이에 기반한 그림자 속성을 계산하여 반환하는 메서드
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor)
}
