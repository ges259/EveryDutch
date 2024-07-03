//
//  RoomSettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

final class RoomSettingVM: RoomSettingVMProtocol {
    private let roomDataManager: RoomDataManagerProtocol
    
    var successLeaveRoom: (() -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
    }
    
    
    var roomManagerIsKicked: Bool {
        print("____________________________")
        print(#function)
        print(self.roomDataManager.checkIsRoomManager)
        print(self.roomDataManager.getNumOfRoomUsers)
        print("____________________________")
        // 유저가 1명이고, 방장인 경우.
        if self.roomDataManager.checkIsRoomManager
            && self.roomDataManager.getNumOfRoomUsers == 1 {
            return true
        }
        return false
    }
    
    /// 사용자가 roomManager인지를 알려주는 변수
    var checkIsRoomManager: Bool {
        return self.roomDataManager.checkIsRoomManager
    }
     
    
    
    var getCurrentRoomID: String? {
        return self.roomDataManager.getCurrentRoomsID
    }
    
    
    func leaveRoom() {
        self.roomDataManager.deleteUserFromRoom(
            isDeletingSelf: true, 
            isRoomManager: self.checkIsRoomManager
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.successLeaveRoom?()
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
}
