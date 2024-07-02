//
//  User.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

protocol EditProviderModel {
    var titleText: String { get }
    var nameText: String { get }
}


struct User: EditProviderModel {
    var personalID: String
    var userName: String
    var userProfileImage: String
    
    init(dictionary: [String: Any]) {
        self.personalID = dictionary[DatabaseConstants.personal_ID] as? String ?? ""
        self.userName = dictionary[DatabaseConstants.user_name] as? String ?? ""
        self.userProfileImage = dictionary[DatabaseConstants.profile_image] as? String ?? ""
    }
    
    var titleText: String {
        return self.userName
    }
    
    var nameText: String {
        return self.personalID
    }
}
