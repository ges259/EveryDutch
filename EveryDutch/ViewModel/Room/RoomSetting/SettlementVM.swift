//
//  SettlementVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation

protocol SettlementVMProtocol {
    func getUserData() -> [RoomUsers]
}

final class SettlementVM: SettlementVMProtocol {
    var roomDataManager: RoomDataManager
    
    var users: [RoomUsers] = []
    
    init(roomDataManager: RoomDataManager) {
        self.roomDataManager = roomDataManager
         
    }
    
    func getUserData() -> [RoomUsers] {
        self.users = self.roomDataManager.getRoomUsers
        return self.users
    }
}
