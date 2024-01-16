//
//  RoomSettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

final class RoomSettingVM: RoomSettingVMProtocol {
    private var roomDataManager: RoomDataManagerProtocol
    
    var users: RoomUserDataDictionary = [:]
    
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
    }
    
    func getUserData() -> RoomUserDataDictionary {
        self.users = self.roomDataManager.getRoomUsersDict
        return self.users
    }
    
}
