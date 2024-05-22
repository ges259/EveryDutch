//
//  CollectionViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

struct MainCollectionViewCellVM: MainCollectionViewCellVMProtocol {
    
    // MARK: - 프로퍼티
    private var roomID: String
    private var room: Rooms
    
    var decoration: Decoration?
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomID: String, room: Rooms) {
        self.roomID = roomID
        self.room = room
    }
    
    
    
    
    
    // MARK: - 데이터 반환
    var getRoomID: String {
        return self.roomID
    }
    var getRoom: Rooms {
        return self.room
    }
    var getDecoration: Decoration? {
        return self.decoration
    }
    
    
    // MARK: - 데이터 업데이트
    mutating func updateDecoration(deco: Decoration?) {
        self.decoration = deco
    }
    
    mutating func updateRoomData(_ room: [String: Any]) {
        guard !room.isEmpty,
              let key = room.keys.first,
              let value = room.values.first as? String
        else { return }
        
        switch key {
        case DatabaseConstants.room_name:
            self.room.roomName = value
            break
        case DatabaseConstants.version_ID:
            self.room.versionID = value
            break
        case DatabaseConstants.manager_name:
            self.room.roomImg = value
            break
        default: break
        }
    }
}
