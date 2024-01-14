//
//  RoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct RoomUsers {
    
    var roomUserName: String
    var roomUserImg: String
    
    init(dictionary: [String: Any]) {
        
        self.roomUserName = dictionary[DatabaseEnum.room_user_name] as? String ?? ""
        self.roomUserImg = dictionary[DatabaseEnum.room_user_image] as? String ?? ""
    }
}
