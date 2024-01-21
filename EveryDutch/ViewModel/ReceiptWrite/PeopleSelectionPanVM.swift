//
//  PeopleSelectionPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

final class PeopleSelectionPanVM: PeopleSelectionPanVMProtocol  {
    
    private var roomDataManager: RoomDataManagerProtocol
    private var users: RoomUserDataDictionary
    
    
    
    
    
    
    // 딕셔너리의 key-value 쌍을 배열로 변환
    func returnUserData(index: Int) -> (key: String, value: RoomUsers) {
        return Array(self.users)[index]
    }
    
    
    
    // MARK: - 선택된 유저
    var selectedUsers: RoomUserDataDictionary = [:] {
        didSet {
            self.bottomBtnClosure?()
        }
    }
    // MARK: - 바텀 버튼 클로저
    var bottomBtnClosure: (() -> Void)?
    
    // MARK: - 유저 찾기
    func getIdToRoomUser(usersID: String) -> Bool {
        if let _ = self.selectedUsers[usersID] {
            return true
        }
        return false
    }
    // MARK: - 바텀 버튼 isEnabled
    var bottomBtnIsEnabled: Bool {
        return self.selectedUsers.count == 0
        ? false
        : true
    }
    // MARK: - 바텀 버튼 생상
    var bottomBtnColor: UIColor {
        return self.selectedUsers.count == 0
        ? UIColor.unselected_Background
        : UIColor.normal_white
    }
    var bottomBtnTextColor: UIColor {
        return self.selectedUsers.count == 0
        ? UIColor.gray
        : UIColor.black
    }
    
    
    
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
    
    
    
    
    // MARK: - 라이프 사이클
    init(selectedUsers: RoomUserDataDictionary?,
         roomDataManager: RoomDataManagerProtocol,
         peopleSelectionEnum: PeopleSeelctionEnum?) {
        self.roomDataManager = roomDataManager
        self.peopleSelectionEnum = peopleSelectionEnum
        
        if let users = selectedUsers {
            self.selectedUsers = users
        }
        self.users = roomDataManager.getRoomUsersDict
    }
    
    
    
    
    
    // MARK: - 다중 선택 모드
    // 셀이 선택되었을 때
    func multipleModeSelectedUsers(index: Int) {
        let user = self.returnUserData(index: index)
        
        // 이미 선택된 유저인지 확인
        if let selectedIndex = self.selectedUsers.firstIndex(
            where: { $0.key == user.key }) {
            // 이미 선택된 유저라면, selectedUsers 배열에서 삭제
            self.selectedUsers.remove(at: selectedIndex)
            
        } else {
            // 새로운 유저라면, selectedUsers 배열에 추가
            self.selectedUsers[user.key] = user.value
        }
    }
    
    // MARK: - 단일 선택 모드
    func singleModeSelectionUser(index: Int) {
        self.selectedUsers.removeAll()
        let user = self.returnUserData(index: index)
        self.selectedUsers[user.key] = user.value
    }
    
    
    
    
}
