//
//  User.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

protocol EditProviderModel {}


struct User: EditProviderModel {
    var personalID: String
    var userName: String
    var userProfile: String
    
    init(dictionary: [String: Any]) {
        self.personalID = dictionary[DatabaseConstants.personal_ID] as? String ?? ""
        self.userName = dictionary[DatabaseConstants.user_name] as? String ?? ""
        self.userProfile = dictionary[DatabaseConstants.user_image] as? String ?? ""
    }
}
