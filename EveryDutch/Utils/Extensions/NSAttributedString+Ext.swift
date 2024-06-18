//
//  NSAttributedString+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

extension NSAttributedString {
    static func configure(text: String,
                          color: UIColor = UIColor.lightGray,
                          font: UIFont = UIFont.systemFont(ofSize: 14))
    -> NSAttributedString{
        return NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font : font])
    }
}
