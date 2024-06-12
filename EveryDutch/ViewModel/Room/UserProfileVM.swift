//
//  UserProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import Foundation

final class UserProfileVM: UserProfileVMProtocol {
    
    let userDecoTuple: UserDecoTuple
    let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         userDecoTuple: UserDecoTuple)
    {
        self.roomDataManager = roomDataManager
        self.userDecoTuple = userDecoTuple
    }
    
    
    lazy var isRoomManager: Bool = {
        return self.roomDataManager.checkIsRoomManager
    }()
    
    
    var btnStvInsets: CGFloat {
        return self.isRoomManager
        ? 30
        : 80
    }
    
    var getUserDecoTuple: UserDecoTuple {
        return self.userDecoTuple
    }
}
