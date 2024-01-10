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
    
    init(roomID: String, versionID: String, dictionary: [String: String]) {
        self.roomID = roomID
        self.versionID = versionID
        self.roomName = dictionary[DatabaseEnum.room_name] ?? ""
        self.roomImg = dictionary[DatabaseEnum.room_image] ?? ""
    }
}
