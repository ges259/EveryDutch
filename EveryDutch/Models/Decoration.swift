//
//  Decoration.swift
//  EveryDutch
//
//  Created by 계은성 on 3/29/24.
//

import UIKit

struct Decoration {
    var blur: Bool
    
    var nameColor: String?
    var titleColor: String?
    var backgroundColor: String?
    
    var backgroundImageUrl: String?
    
    
    init(dictionary: [String: Any]) {
        self.blur = dictionary[DatabaseConstants.blur_Effect] as? Bool ?? false
        self.backgroundImageUrl = dictionary[DatabaseConstants.background_Image] as? String ?? ""
        self.backgroundColor = dictionary[DatabaseConstants.background_Color] as? String ?? ""
        self.nameColor = dictionary[DatabaseConstants.name_Color] as? String ?? ""
        self.titleColor = dictionary[DatabaseConstants.title_Color] as? String ?? ""
    }
    
    
    var getBackgroundColor: UIColor? {
        return UIColor(hex: self.backgroundColor,
                       defaultColor: .medium_Blue)
    }
    var getTitleColor: UIColor? {
        return UIColor(hex: self.titleColor,
                       defaultColor: .black)
    }
    var getNameColor: UIColor? {
        return UIColor(hex: self.nameColor,
                       defaultColor: .placeholder_gray)
    }
}
