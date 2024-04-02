//
//  Decoration.swift
//  EveryDutch
//
//  Created by 계은성 on 3/29/24.
//

import Foundation

struct Decoration {
    var blur: Bool
    var backgroundColor: String?
    var pointColor: String?
    var titleColor: String?
    
    var profileImage: String?
    var backgroundImage: String?
    
    
    init(dictionary: [String: Any]) {
        self.blur = dictionary[DatabaseConstants.blur_Effect] as? Bool ?? false
        self.profileImage = dictionary[DatabaseConstants.card_profile_image] as? String ?? ""
        self.backgroundImage = dictionary[DatabaseConstants.card_background_image] as? String ?? ""
        self.backgroundColor = dictionary[DatabaseConstants.context] as? String ?? ""
        self.pointColor = dictionary[DatabaseConstants.context] as? String ?? ""
        self.titleColor = dictionary[DatabaseConstants.context] as? String ?? ""
    }
}
