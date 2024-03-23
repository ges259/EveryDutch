//
//  User.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct User {
    var personalID: String
    var userName: String
    var userProfile: String
    
    init(dictionary: [String: Any]) {
        self.personalID = dictionary[DatabaseConstants.personal_ID] as? String ?? ""
        self.userName = dictionary[DatabaseConstants.user_name] as? String ?? ""
        self.userProfile = dictionary[DatabaseConstants.user_image] as? String ?? ""
    }
    
//    var cellData: [CellData] {
//        return [CellData(type: ., detail: <#T##String#>)]
//    }
}
