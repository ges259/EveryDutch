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
         // 입력 문자열에서 'background:'를 제거하고 트리밍
         let trimmedInput = input.replacingOccurrences(of: "background:", with: "").trimmingCharacters(in: .whitespaces)
         
         // 색상 코드인지 확인
         if trimmedInput.hasPrefix("#") && trimmedInput.count == 7 {
             self.backgroundColor = trimmedInput
             self.backgroundImageUrl = nil
         }
         // URL인지 확인
         else if let url = URL(string: trimmedInput), url.scheme == "http" || url.scheme == "https" {
             self.backgroundImageUrl = trimmedInput
             self.backgroundColor = nil
         }
     }
    
    
    
    var getBackgroundColor: UIColor? {
        return UIColor(hex: self.backgroundColor,
                       defaultColor: .red)
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
