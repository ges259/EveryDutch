//
//  RoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct RoomUsers {
    var userID: String
    var roomName: String
    var roomImg: String
    
    init(userID: String, dictionary: [String: Any]) {
        self.userID = userID
        self.roomName = dictionary[DatabaseEnum.room_user_name] as? String ?? ""
        self.roomImg = dictionary[DatabaseEnum.room_user_image] as? String ?? ""
    }
}
