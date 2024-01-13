//
//  ReceiptWriteCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

struct ReceiptWriteCellVM {
    var userID: String
    var profileImageURL: String
    var userName: String
    
    
    var price: String = ""
    
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? .person_Fill_Img
        : .x_Mark_Img
    }
    
    
    init(roomUsers: RoomUsers) {
        self.userID = roomUsers.userID
        self.profileImageURL = roomUsers.roomImg
        self.userName = roomUsers.roomName
    }
    
    
    
    
}
