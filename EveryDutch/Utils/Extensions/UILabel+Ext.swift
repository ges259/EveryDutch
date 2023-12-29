//
//  UILabel+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

extension UILabel {
    static func configureLbl(text: String = "",
                             textColor: UIColor = UIColor.black,
                             font: UIFont,
                             backgroundColor: UIColor = .clear,
                             textAlignment: NSTextAlignment = .left)
    -> UILabel {
        
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = textColor
        lbl.font = font
        lbl.textAlignment = textAlignment
        lbl.backgroundColor = backgroundColor
        return lbl
    }
}
