//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

struct ReceiptScreenPanVM {
    
    
    
    var receipt: Receipt
    var roomUsers: [RoomUsers]
    
    init(receipt: Receipt,
         users: [RoomUsers]) {
        self.receipt = receipt
        self.roomUsers = users
    }
    
    
    
     
}
