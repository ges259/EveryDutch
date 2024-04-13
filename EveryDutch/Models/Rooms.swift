//
//  Rooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct Rooms: EditProviderModel {
    var roomID: String
    var versionID: String
    var roomName: String
    var roomImg: String
    
    init(roomID: String, dictionary: [String: Any]) {
        self.roomID = roomID
        self.roomName = dictionary[DatabaseConstants.room_name] as? String ?? ""
        self.versionID = "\(dictionary[DatabaseConstants.version_ID] as? Int ?? 0)"
        self.roomImg = dictionary[DatabaseConstants.manager_name] as? String ?? ""
    }
}
