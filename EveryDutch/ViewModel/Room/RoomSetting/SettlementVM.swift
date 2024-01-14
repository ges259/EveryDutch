//
//  SettlementVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation

final class SettlementVM: SettlementVMProtocol {
    var roomDataManager: RoomDataManager
    
    var users: RoomUserDataDictionary = [:]
    
    init(roomDataManager: RoomDataManager) {
        self.roomDataManager = roomDataManager
         
    }
    
    func getUserData() -> RoomUserDataDictionary {
        self.users = self.roomDataManager.getRoomUsersDict
        return self.users
    }
    
    var getRoomMoneyData: [MoneyData] {
        return self.roomDataManager.getRoomMoneyData
    }
    
    
}
