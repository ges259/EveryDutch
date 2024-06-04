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
         self.nameColor = dictionary[DatabaseConstants.name_Color] as? String
         self.titleColor = dictionary[DatabaseConstants.title_Color] as? String
         
         let backgroundString = dictionary[DatabaseConstants.background_Data] as? String
         self.identifyBackground(input: backgroundString)
     }

    
    mutating func identifyBackground(input: String?) {
        guard let input = input else { return }
        
        if input.checkIsHexColor() {
            self.backgroundColor = input
            self.backgroundImageUrl = nil
        } else {
            self.backgroundImageUrl = input
            self.backgroundColor = nil
        }
    }
    
    

    var getBackgroundColor: UIColor? {
        return UIColor(hex: self.backgroundColor,
                       defaultColor: .clear)
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
