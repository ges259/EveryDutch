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
        print(#function)
        print(self.roomDataManager.getNumOfRoomUsers)
        print(self.roomDataManager.checkIsRoomManager)
        print(self.roomDataManager.getNumOfRoomUsers == 1
              && self.roomDataManager.checkIsRoomManager)
        
        if self.roomDataManager.getNumOfRoomUsers == 1
            && self.roomDataManager.checkIsRoomManager {
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
            isDeletingSelf: false
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
