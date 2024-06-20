//
//  UIColor+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat,
                    g: CGFloat,
                    b: CGFloat,
                    alpha: CGFloat = 1)
    -> UIColor {
        return UIColor(
            red: r/255,
            green: g/255,
            blue: b/255,
            alpha: alpha
        )
    }
    
    /// 앱의 흰색 기본 생상
    static let normal_white: UIColor = UIColor.rgb(
        r: 224, g: 236, b: 255)
    /// 기본 생상 - 배경 생상
    static let base_Blue: UIColor = UIColor.rgb(
        r: 204, g: 224, b: 255)
    /// 배경과 구분을 위한 생상 - 레이블 등
    static let medium_Blue: UIColor = UIColor.rgb(
        r: 178, g: 214, b: 255)
    
    /// 조건이 충족되지 않았을 때 글자 생상
    static let unqualified_black: UIColor = UIColor.rgb(
        r: 92, g: 86, b: 86)
    /// 사람 이미지의 생상
    static let point_Blue: UIColor = UIColor.rgb(
        r: 107, g: 147, b: 251)
    /// 강조 생상 - 버튼 등
    static let deep_Blue: UIColor = UIColor.rgb(
        r: 135, g: 196, b: 255)
    /// 삭제된 셀의 생상
    static let deleted_red: UIColor = UIColor.rgb(
        r: 251, g: 181, b: 183)
    /// 선택되지 않은 세그먼트 컨트롤 생상
    static let unselected_gray: UIColor = UIColor.rgb(
        r: 198, g: 216, b: 243)
    static let unselected_Background: UIColor = UIColor.rgb(
        r: 209, g: 216, b: 229)
    
    
    static let placeholder_gray: UIColor = UIColor.rgb(
        r: 123, g: 121, b: 166)
    
    static let backgroundGray: UIColor = UIColor.rgb(
        r: 123, g: 121, b: 166, alpha: 0.5)
    static let disableBtn: UIColor = UIColor.rgb(
        r: 151, g: 199, b: 246)
}










// MARK: - Hex값 변환
extension UIColor {
    // UIColor를 HEX 문자열로 변환
    func toHexString() -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }

    // HEX 문자열로부터 UIColor 생성
    convenience init?(hex: String?, defaultColor: UIColor = .clear) {
        guard let hex = hex?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: ""),
              hex.count == 6, // HEX 코드는 6자리여야 함
              let rgbValue = UInt64(hex, radix: 16) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}






// MARK: - 색상 피커
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
        return UIColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness,
                       alpha: alpha)
    }
    
    /// 색상의 밝기 성분 값
    var brightness: CGFloat {
        var brightness: CGFloat = 0
        self.getHue(nil,
                    saturation: nil,
                    brightness: &brightness,
                    alpha: nil)
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

