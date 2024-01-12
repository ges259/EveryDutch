//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWirteVMProtocol { 
    
    
    
    
    
    
    
    var roomDataManager: RoomDataManager
    
    var numOfUsers: Int {
        return self.roomDataManager.numOfRoomUsers
    }
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManager) {
        self.roomDataManager = roomDataManager
        
        
    }
    
    
    
}
