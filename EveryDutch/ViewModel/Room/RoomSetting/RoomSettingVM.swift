//
//  RoomSettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

final class RoomSettingVM: RoomSettingVMProtocol {
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
