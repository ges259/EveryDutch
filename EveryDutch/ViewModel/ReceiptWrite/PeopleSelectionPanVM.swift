//
//  PeopleSelectionPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

final class PeopleSelectionPanVM: PeopleSelectionPanVMProtocol  {
    
    private var roomDataManager: RoomDataManagerProtocol
    private var users: RoomUserDataDict
    
    
    
    
    // 딕셔너리의 key-value 쌍을 배열로 변환
    func returnUserData(index: Int) -> UserDataTuple {
        return Array(self.users)[index]
    }
    
    
    
    // MARK: - 선택된 유저
    var selectedUsers: RoomUserDataDict = [:] {
        didSet {
            print("selectedUsers --- \(selectedUsers)")
        }
    }
    
    var addedUsers: RoomUserDataDict = [:] {
        didSet {
            print("addedUsers --- \(addedUsers)")
            self.bottomBtnClosure?()
        }
    }
    var removedSelectedUsers: RoomUserDataDict = [:] {
        didSet {
            self.bottomBtnClosure?()
            print("removedSelectedUsers --- \(removedSelectedUsers)")
        }
    }
    
    
    
    
    var isFirst: Bool = true
    
    
    // MARK: - 바텀 버튼 클로저
    var bottomBtnClosure: (() -> Void)?
    
    
    
    // MARK: - 선택된 유저의 수
    private var usersCount: Bool {
        let removedUsers = self.removedSelectedUsers.count
        let addedUsers = self.addedUsers.count
        let totalUsersCount = removedUsers + addedUsers
        
        return totalUsersCount == 0
        ? true
        : false
    }
    
    // MARK: - 유저 찾기
    func getIdToRoomUser(usersID: String) -> Bool {
        if self.addedUsers[usersID] != nil
            || self.selectedUsers[usersID] != nil {
            
            return true
        }
        
        return false
    }
    // MARK: - 바텀 버튼 isEnabled
    var bottomBtnIsEnabled: Bool {
        return self.usersCount
        ? false
        : true
    }
    // MARK: - 바텀 버튼 생상
    var bottomBtnColor: UIColor {
        return self.usersCount
        ? UIColor.unselected_Background
        : UIColor.normal_white
    }
    var bottomBtnTextColor: UIColor {
        return self.usersCount
        ? UIColor.gray
        : UIColor.black
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Fix
    
    
    
    
    // MARK: - 모드
    var peopleSelectionEnum: PeopleSeelctionEnum?
    
    
    // MARK: - 현재 모드
    var isSingleMode: Bool {
        return self.peopleSelectionEnum == .singleSelection
        ? true
        : false
    }
    
    // MARK: - 유저의 수
    var numOfUsers: Int {
        return self.users.count
    }
    
    // MARK: - 상단 레이블 텍스트
    var topLblText: String {
        return self.peopleSelectionEnum == .singleSelection
        ? "계산한 사람을 선택해 주세요."
        : "계산할 사람을 선택해 주세요."
    }
    // MARK: - 바텀 버튼 텍스트
    var bottomBtnText: String {
        return self.peopleSelectionEnum == .singleSelection
        ? "선택 완료"
        : "선택 완료"
    }
    
    
    func getSelectedUsersIndexPath() -> IndexPath? {
        // 해당 키를 찾지 못한 경우 nil을 반환합니다.
        guard let index = self.getIndex() else {
            return nil
        }
        return IndexPath(row: index, section: 0)
    }
    
    
    private func getIndex() -> Int? {
        // `selectedUsers`의 첫 번째 키를 가져옵니다.
        guard let key = self.selectedUsers.keys.first else { return nil }
        // `users` 딕셔너리에서 해당 키의 인덱스를 찾습니다.
        if let index = Array(self.users.keys).firstIndex(of: key) {
            // 찾은 인덱스로 `IndexPath`를 생성하여 반환합니다.
            return index
        }
        return nil
    }
    
    
    // MARK: - 라이프 사이클
    init(selectedUsers: RoomUserDataDict?,
         roomDataManager: RoomDataManagerProtocol,
         peopleSelectionEnum: PeopleSeelctionEnum?) {
        self.roomDataManager = roomDataManager
        self.peopleSelectionEnum = peopleSelectionEnum
        
        if let users = selectedUsers {
            self.selectedUsers = users
        }
        self.users = roomDataManager.getRoomUsersDict
    }
}
    
    
    
    
    
    
    
 


// MARK: - 다중 선택 모드

extension PeopleSelectionPanVM {
    func multipleModeSelectedUsers(index: Int) {
        // 선택된 유저의 데이터 가져오기
        let user = self.returnUserData(index: index)
        
        // 가져온 유저가 삭제된 상태 (선택되어있지 않은 상태)
        if self.removedSelectedUsers[user.key] != nil {
            self.removeRemovedUser(user)
            
            
            // 가져온 유저에 있다면 (선택되어있는 상태)
        } else if self.selectedUsers[user.key] != nil {
            self.removeSelectedUser(user)
            
            
            // 추가된 유저에 있다면 (선택되어있는 상태)
        } else if self.addedUsers[user.key] != nil {
            self.removeAddedUser(user.key)
            
            
            // 유저 추가 (선택되어있지 않은 상태)
        } else {
            self.addUser(user)
        }
    }
    
    // MARK: - [삭제] 삭제된 유저
    // 선택된 유저가 삭제된 경우를 확인
    private func removeRemovedUser(_ user: UserDataTuple) {
        self.removedSelectedUsers.removeValue(forKey: user.key)
        self.selectedUsers[user.key] = user.value
    }
    
    // MARK: - [삭제] 가져온 유저
    private func removeSelectedUser(_ user: UserDataTuple) {
        self.selectedUsers.removeValue(forKey: user.key)
        self.removedSelectedUsers[user.key] = user.value
    }
    
    // MARK: - [삭제] 추가된 유저
    private func removeAddedUser(_ userID: String) {
        self.addedUsers.removeValue(forKey: userID)
    }
    
    // MARK: - [추가] 추가된 유저
    private func addUser(_ user: UserDataTuple) {
        self.addedUsers[user.key] = user.value
    }
}
    
    
    
    
    
    
    
    


// MARK: - 단일 선택 모드

extension PeopleSelectionPanVM {
    func singleModeSelectionUser(index: Int) {
        self.addedUsers.removeAll()
        let user = self.returnUserData(index: index)
        self.addedUsers[user.key] = user.value
    }
}
