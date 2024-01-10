//
//  User.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct User {
    var email: String
    var personalID: String
    var userName: String
    var userProfile: String
    
    init(dictionary: [String: Any]) {
        self.email = dictionary[DatabaseEnum.email] as? String ?? ""
        self.personalID = dictionary[DatabaseEnum.personal_ID] as? String ?? ""
        self.userName = dictionary[DatabaseEnum.user_name] as? String ?? ""
        self.userProfile = dictionary[DatabaseEnum.user_image] as? String ?? ""
    }
}
