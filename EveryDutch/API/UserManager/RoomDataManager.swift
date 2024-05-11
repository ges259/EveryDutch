//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

final class RoomDataManager: RoomDataManagerProtocol {
    static let shared: RoomDataManagerProtocol = RoomDataManager(
        roomsAPI: RoomsAPI.shared)
    
    var roomsAPI: RoomsAPIProtocol
    
    
    // MARK: - 라이프사이클
    init(roomsAPI: RoomsAPIProtocol) {
        self.roomsAPI = roomsAPI
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    /// roomID / versionID / roomNam / roomImg
    var currentRoomData: Rooms?
    
    var rooms: [Rooms] = []
    
    
    
    
    
    /// [userID : User]로 이루어진 딕셔너리
    /// Receipt관련 화면에서 userID로 User의 데이터 사용
    /// ReceiptWriteVC에서 유저의 정보 사용
    var roomUserDataDict: [String : User] = [:]
    
    // UsersTableViewCell 관련 프로퍼티들
    // [UsersID : IndexPath]
    var userIDToIndexPathMap: [String: IndexPath] = [:]
    var cellViewModels: [UsersTableViewCellVMProtocol] = []
    
    
    
    
    
    var cumulativeAmount: CumulativeAmountDictionary = [:]
    var paybackData: Payback?
    // 두 작업 완료 여부를 추적하는 플래그
    // 플래그 대신 상태 추적을 위한 집합 사용
    var loadedStates: Set<String> = []
    let cumulativeAmountLoadedKey = "cumulativeAmount"
    let paybackLoadedKey = "payback"
    // 바뀐 인덱스패스 저장
    var changedIndexPaths: [IndexPath] = []


    
    
    
    
    
// MARK: - 유저 테이블
    
    
    
    // MARK: - 방의 개수
    var getNumOfRoomUsers: Int {
        return self.cellViewModels.count
    }
    
    
    // MARK: - 뷰모델 리턴
    func getViewModel(index: Int) -> UsersTableViewCellVMProtocol {
        return self.cellViewModels[index]
    }
    
    
    
// MARK: - 특정 유저 정보 리턴
    
    var getRoomUsersDict: RoomUserDataDict {
        return self.roomUserDataDict
    }
    
    /// 인데스패스 리턴
    func getUserIndexPath(userID: String) -> IndexPath? {
        return self.userIDToIndexPathMap[userID]
    }
    
    /// 누적 금액 리턴
    func getIDToCumulativeAmount(userID: String) -> Int {
        return self.cumulativeAmount[userID]?.cumulativeAmount ?? 0
    }
    
    /// 페이백 값
    func getIDToPayback(userID: String) -> Int {
        return self.paybackData?.payback[userID] ?? 0
    }
    
    /// Receipt가 필요한 화면에서 userID로 User의 정보를 알기 위해 사용
    func getIdToRoomUser(usersID: String) -> User {
        return self.roomUserDataDict[usersID]
        ?? User(dictionary: [:])
    }
    
    
    
    
    
    
// MARK: - 현재 방 정보

    
    
    // MARK: - 방 데이터 가져가기
    var getRooms: [Rooms] {
        return self.rooms
    }
    
    // MARK: - 방 데이터 추가
    func addedRoom(room: Rooms) {
        self.rooms.insert(room, at: 0)
    }
    
    // MARK: - 선택된 현재 방 저장
    func saveCurrentRooms(index: Int) {
        self.currentRoomData = self.rooms[index]
    }
    
    // MARK: - 방의 이름
    var getCurrentRoomName: String? {
        return self.currentRoomData?.roomID
    }
    
    // MARK: - 방 ID
    var getCurrentRoomsID: String? {
        return self.currentRoomData?.roomID
    }
    
    // MARK: - 버전 ID
    var getCurrentVersion: String? {
        return self.currentRoomData?.versionID
    }
    
    
    
    
    
    // MARK: - 노티피케이션 Post
    func postNotification(
        name: Notification.Name,
        eventType: NotificationInfoString,
        indexPath: [IndexPath])
    {
        
        print(#function)
        print(indexPath)
        print(self.cellViewModels.count)
        
        // 노티피케이션 전송
        NotificationCenter.default.post(
            name: name,
            object: nil,
            userInfo: [eventType.notificationName: indexPath]
        )
    }
}





enum NotificationInfoString {
    case updated
    case added
    case removed
    case initialLoad
    
    var notificationName: String {
        switch self {
        case .initialLoad:  return "initialLoad"
        case .added:        return "added"
        case .removed:      return "removed"
        case .updated:      return "updated"
        }
    }
}
