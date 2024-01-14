//
//  ReceiptWriteCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

struct ReceiptWriteCellVM: ReceiptWriteCellVMProtocol {
    var userID: String
    var profileImageURL: String
    var userName: String
    
    
    var price: String = ""
    
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? .person_Fill_Img
        : .x_Mark_Img
    }
    
    
    init(userID: String,
         roomUsers: RoomUsers) {
        self.userID = userID
        self.profileImageURL = roomUsers.roomUserImg
        self.userName = roomUsers.roomUserName
    }
    
    
    
    
}
