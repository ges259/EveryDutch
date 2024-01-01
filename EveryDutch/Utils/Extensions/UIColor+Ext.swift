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
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    /// 앱의 흰색 기본 생상
    static let normal_white: UIColor = UIColor.rgb(r: 224, g: 236, b: 255)
    /// 기본 생상 - 배경 생상
    static let base_Blue: UIColor = UIColor.rgb(r: 204, g: 224, b: 255)
    /// 배경과 구분을 위한 생상 - 레이블 등
    static let medium_Blue: UIColor = UIColor.rgb(r: 178, g: 214, b: 255)
    
    /// 조건이 충족되지 않았을 때 글자 생상
    static let unqualified_black: UIColor = UIColor.rgb(r: 92, g: 86, b: 86)
    /// 사람 이미지의 생상
    static let point_Blue: UIColor = UIColor.rgb(r: 107, g: 147, b: 251)
    /// 강조 생상 - 버튼 등
    static let deep_Blue: UIColor = UIColor.rgb(r: 135, g: 196, b: 255)
    /// 삭제된 셀의 생상
    static let deleted_red: UIColor = UIColor.rgb(r: 251, g: 181, b: 183)
    /// 선택되지 않은 세그먼트 컨트롤 생상
    static let unselected_gray: UIColor = UIColor.rgb(r: 198, g: 216, b: 243)
    
    static let placeholder_gray: UIColor = UIColor.rgb(r: 123, g: 121, b: 166)
    
    static let backgroundGray: UIColor = UIColor.rgb(r: 123, g: 121, b: 166, alpha: 0.5)
}
