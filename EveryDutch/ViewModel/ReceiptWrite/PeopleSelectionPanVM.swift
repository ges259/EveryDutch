//
//  PeopleSelectionPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import Foundation

final class PeopleSelectionPanVM: PeopleSelectionPanVMProtocol  {
    
    var roomDataManager: RoomDataManager
    
    var users: [RoomUsers]
    var selectedUsers: [RoomUsers] = [] {
        didSet {
            dump(selectedUsers)
        }
    }
    
    
    
    
    var numOfUsers: Int {
        return self.users.count
    }
    
    init(roomDataManager: RoomDataManager) {
        self.roomDataManager = roomDataManager
        self.users = roomDataManager.getRoomUsers
    }
    
    // 셀이 선택되었을 때
    func selectedUser(index: Int) {
        let user = self.users[index]
        
        // 이미 선택된 유저인지 확인
        if let selectedIndex = self.selectedUsers.firstIndex(
            where: { $0.userID == user.userID }) {
            
            // 이미 선택된 유저라면, selectedUsers 배열에서 삭제
            self.selectedUsers.remove(at: selectedIndex)
            
        } else {
            // 새로운 유저라면, selectedUsers 배열에 추가
            self.selectedUsers.append(user)
            
        }
    }
    
    
    
    
}
