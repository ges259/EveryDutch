//
//  UIButton+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

extension UIButton {
    static func btnWithImg(imageEnum: imageEnum,
                           imageSize: CGFloat,
                           tintColor: UIColor = .black,
                           backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: imageSize,
            weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        btn.setImage(image, for: .normal)
            btn.tintColor = tintColor
            btn.backgroundColor = backgroundColor
        return btn
    }
    
    static func btnWithTitle(title: String = "",
                             titleColor: UIColor = UIColor.black,
                             font: UIFont,
                             backgroundColor: UIColor)
    -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = font
        btn.backgroundColor = backgroundColor
        return btn
    }
}
