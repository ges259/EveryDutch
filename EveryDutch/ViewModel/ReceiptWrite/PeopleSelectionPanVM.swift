//
//  PeopleSelectionPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import Foundation

final class PeopleSelectionPanVM: PeopleSelectionPanVMProtocol  {
    
    private var roomDataManager: RoomDataManagerProtocol
    
    var users: RoomUserDataDictionary
    
    // 딕셔너리의 key-value 쌍을 배열로 변환
    var usersKeyValueArray: [(key: String, value: RoomUsers)] {
        return Array(users)
    }
    
    
    
    var selectedUsers: RoomUserDataDictionary = [:] {
        didSet {
            dump(selectedUsers)
        }
    }
    
    
    
    
    var numOfUsers: Int {
        return self.users.count
    }
    
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
        self.users = roomDataManager.getRoomUsersDict
    }
    
    // 셀이 선택되었을 때
    func selectedUser(index: Int) {
//        let user = self.users[index]
        
        // MARK: - 픽스
//        // 이미 선택된 유저인지 확인
//        if let selectedIndex = self.selectedUsers.firstIndex(
//            where: { $0.userID == user.userID }) {
//            
//            // 이미 선택된 유저라면, selectedUsers 배열에서 삭제
//            self.selectedUsers.remove(at: selectedIndex)
//            
//        } else {
//            // 새로운 유저라면, selectedUsers 배열에 추가
//            self.selectedUsers.append(user)
//            
//        }
    }
    
    
    
    
}
