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
    
    
//    var rooms: [Rooms] = []
//    private var currentRoomData: Rooms?
    
    
//    var currentRoom = [String: Rooms]()
    // 현재 선택된 Rooms
    var currentRoom: (roomID: String, room: Rooms)?
    
//    var roomDataDict =  [String: Rooms]()
    var roomIDToIndexPathMap =  [String: IndexPath]()
    var roomsCellViewModels = [MainCollectionViewCellVMProtocol]()
    
    
    
    
    
    /// [userID : User]로 이루어진 딕셔너리
    /// Receipt관련 화면에서 userID로 User의 데이터 사용
    /// ReceiptWriteVC에서 유저의 정보 사용
    var roomUserDataDict: [String : User] = [:]
    
    // UsersTableViewCell 관련 프로퍼티들
    // [UsersID : IndexPath]
    var userIDToIndexPathMap: [String: IndexPath] = [:]
    var usersCellViewModels: [UsersTableViewCellVMProtocol] = []
    
    
    
    
    
    var cumulativeAmount: CumulativeAmountDictionary = [:]
    var paybackData: Payback?
    // 두 작업 완료 여부를 추적하는 플래그
    // 플래그 대신 상태 추적을 위한 집합 사용
    var loadedStates: Set<String> = []
    let cumulativeAmountLoadedKey = "cumulativeAmount"
    let paybackLoadedKey = "payback"
    // 바뀐 인덱스패스 저장
    var changedIndexPaths: [IndexPath] = []


    
    
    
    
    
// MARK: - User 정보
    
    
    
    // MARK: - 방의 개수
    var getNumOfRoomUsers: Int {
        return self.usersCellViewModels.count
    }
    
    
    // MARK: - 뷰모델 리턴
    func getUsersViewModel(index: Int) -> UsersTableViewCellVMProtocol {
        return self.usersCellViewModels[index]
    }
    
    
    
    // MARK: - 특정 유저 정보 리턴
    var getRoomUsersDict: RoomUserDataDict {
        return self.roomUserDataDict
    }
    
    /// Receipt가 필요한 화면에서 userID로 User의 정보를 알기 위해 사용
    func getIdToRoomUser(usersID: String) -> User {
        return self.roomUserDataDict[usersID]
        ?? User(dictionary: [:])
    }
    
    /// 인데스패스 리턴
//    func getUserIndexPath(userID: String) -> IndexPath? {
//        return self.userIDToIndexPathMap[userID]
//    }
    
    /// 누적 금액 리턴
    func getIDToCumulativeAmount(userID: String) -> Int {
        return self.cumulativeAmount[userID]?.cumulativeAmount ?? 0
    }
    
    /// 페이백 값
    func getIDToPayback(userID: String) -> Int {
        return self.paybackData?.payback[userID] ?? 0
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// MARK: - Rooms 정보

    
    var getNumOfRooms: Int {
        return self.roomsCellViewModels.count
    }
    
    func getRoomsViewModel(index: Int) -> MainCollectionViewCellVMProtocol {
        return self.roomsCellViewModels[index]
    }
    
    
    
    
    
    
    // MARK: - 현재 방
    
    
    
    // MARK: - 저장
    func saveCurrentRooms(index: Int) {
        // 배열 범위 검사
        guard index >= 0, index < self.roomsCellViewModels.count else {
            print("Index out of range")
            return
        }
        // 인덱스로부터 뷰모델 가져오기
        let viewModel = self.roomsCellViewModels[index]
        // 뷰모델로부터 roomID 추출
        let roomID = viewModel.getRoomID
        let roomData = viewModel.getRoom
        // currentRoom 설정
        self.currentRoom = (roomID: roomID, room: roomData)
    }
    
    // MARK: - 방의 이름
    var getCurrentRoomName: String? {
        let currentRoom = self.currentRoom?.room
        return currentRoom?.roomName
    }
    
    // MARK: - 방 ID
    var getCurrentRoomsID: String? {
        return self.currentRoom?.roomID
    }

    // MARK: - 버전 ID
    var getCurrentVersion: String? {
        let currentRoom = self.currentRoom?.room
        return currentRoom?.versionID
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 노티피케이션 Post
    func postNotification(
        name: Notification.Name,
        eventType: NotificationInfoString,
        indexPath: [IndexPath])
    {
        
        print(#function)
        print(indexPath)
        print(self.usersCellViewModels.count)
        
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
// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)
extension Notification.Name {
//    static let cumulativeAmountUpdated = Notification.Name("cumulativeAmountUpdated")
//    static let paybackDataUpdated = Notification.Name("paybackDataUpdated")
    static let roomDataChanged = Notification.Name("roomDataChanged")
    static let userDataChanged = Notification.Name("userDataChanged")
    static let financialDataUpdated = Notification.Name("financialDataUpdated")
}
