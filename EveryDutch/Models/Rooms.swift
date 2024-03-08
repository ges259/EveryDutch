//
//  Rooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct Rooms {
    var roomID: String
    var versionID: String
    var roomName: String
    var roomImg: String
    
    init(roomID: String, versionID: String, dictionary: [String: Any]) {
        self.roomID = roomID
        self.versionID = versionID
        self.roomName = dictionary[DatabaseConstants.room_name] as? String ?? ""
        self.roomImg = dictionary[DatabaseConstants.room_image] as? String ?? ""
    }
}
