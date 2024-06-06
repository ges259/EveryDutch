//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

final class RoomDataManager: RoomDataManagerProtocol {
    static let shared: RoomDataManagerProtocol = RoomDataManager(
        roomsAPI: RoomsAPI.shared,
        receiptAPI: ReceiptAPI.shared)
    
    var roomsAPI: RoomsAPIProtocol
    var receiptAPI: ReceiptAPIProtocol
    
    // MARK: - 라이프사이클
    init(roomsAPI: RoomsAPIProtocol,
         receiptAPI: ReceiptAPIProtocol) {
        self.roomsAPI = roomsAPI
        self.receiptAPI = receiptAPI
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    
    
    
    // MARK: - Rooms
    // 현재 선택된 Rooms
    private var currentRoom: (roomID: String, room: Rooms)?
    
    
    var roomIDToIndexPathMap = [String: IndexPath]()
    var roomsCellViewModels = [MainCollectionViewCellVMProtocol]()
    
    /// 디바운스 타이머
    var changedRoomIndexPaths: [String: [IndexPath]] = [:]
    var roomDataDebounceWorkItem: DispatchWorkItem?
    let roomDataQueue = DispatchQueue(label: "room-data-queue", qos: .userInitiated)

    
    
    
    // MARK: - RoomUsrs
    /// [userID : User]로 이루어진 딕셔너리
    /// Receipt관련 화면에서 userID로 User의 데이터 사용
    /// ReceiptWriteVC에서 유저의 정보 사용
    var roomUserDataDict = [String : User]()
    // UsersTableViewCell 관련 프로퍼티들
    // [UsersID : IndexPath]
    var userIDToIndexPathMap = [String: IndexPath]()
    var usersCellViewModels = [UsersTableViewCellVMProtocol]()
    
    

    
    var changedUserIndexPaths = [IndexPath]()
    var userDataDebounceWorkItem: DispatchWorkItem?
    let userDataQueue = DispatchQueue(label: "money-data-queue",
                                       qos: .userInitiated)
    
    

    
    
    // MARK: - MoneyData
    // 바뀐 인덱스패스 저장
    var changedReceiptIndexPaths = [IndexPath]()
    /// 디바운스 타이머
    var moneyDataDebounceWorkItem: DispatchWorkItem?
    let moneyDataQueue = DispatchQueue(label: "money-data-queue",
                                       qos: .userInitiated)
    // 디바운싱 -> 1.5초 후에 실행
    let debounceInterval: CGFloat = 1.5
    

    
    
    
    
    // MARK: - Receipt
    /// 영수증 배열
    var receiptIDToIndexPathMap = [String: IndexPath]()
    /// 영수증 테이블 셀의 뷰모델
    var receiptCellViewModels = [ReceiptTableViewCellVMProtocol]()
    var hasMoreData: Bool = true

    
    
    
    
    var roomUsersInitialLoad: Bool = true
    var receiptInitialLoad = true
    
    
    func startLoadRoomData(completion: @escaping (Result<Void, ErrorEnum>) -> Void) {
        // 초기 로드일 때 모든 데이터 초기화
        self.removeRoomsUsersObserver()
        
        self.loadRoomUsers { [weak self] result in
            guard let self = self else {
                completion(.failure(.readError))
                return
            }
            switch result {
            case .success():
                self.loadFinancialData()
                self.loadReceipt(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 노티피케이션 Post
    func postNotification(
        name: Notification.Name,
        eventType: NotificationInfoString,
        indexPath: [IndexPath])
    {
        DispatchQueue.main.async {
            print("\(#function) ----- \(name) ----- \(eventType.notificationName)")
            dump(indexPath)
            // 비어있다면, 노티피케이션을 post하지 않음
            guard !indexPath.isEmpty else { return }
            
            // 노티피케이션 전송
            NotificationCenter.default.post(
                name: name,
                object: nil,
                userInfo: [eventType.notificationName: indexPath]
            )
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 초기화
    /// RoomUsers / User에 대한 observer를 삭제하는 메서드
    func removeRoomsUsersObserver() {
        // 옵저버 삭제
        self.roomsAPI.removeRoomUsersAndUserObserver()
        self.receiptAPI.resetReceiptLastKey()
        // 정산방에 대한 데이터 삭제
        self.resetRoomData()
    }
    func resetRoomData() {
        self.usersCellViewModels = []
        self.userIDToIndexPathMap = [:]
        self.roomUserDataDict = [:]
        self.receiptInitialLoad = true
        self.roomUsersInitialLoad = true
//        self.userDataDebounceWorkItem = nil
        self.userDataDebounceWorkItem?.cancel()
        self.roomDataDebounceWorkItem?.cancel()
        
        self.changedReceiptIndexPaths = []
        self.moneyDataDebounceWorkItem?.cancel()
        self.receiptIDToIndexPathMap = [:]
        self.receiptCellViewModels = []
        self.hasMoreData = true
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - User 정보
    /// 방의 개수
    var getNumOfRoomUsers: Int {
        return self.usersCellViewModels.count
    }
    
    /// 뷰모델 리턴
    func getUsersViewModel(index: Int) -> UsersTableViewCellVMProtocol {
        return self.usersCellViewModels[index]
    }
    
    /// 특정 유저 정보 리턴
    var getRoomUsersDict: RoomUserDataDict {
        return self.roomUserDataDict
    }
    
    /// userID로 User의 정보를 알기 위해 사용
    func getIdToRoomUser(usersID: String) -> User {
        return self.roomUserDataDict[usersID]
        ?? User(dictionary: [:])
    }
    
    /// 인데스패스 리턴
//    func getUserIndexPath(userID: String) -> IndexPath? {
//        return self.userIDToIndexPathMap[userID]
//    }
    
    /// roomUserDataDict의 userID의 배열을 리턴하는 변수
//    var getRoomUsersKeyArray: [String] {
//        return Array(self.roomUserDataDict.keys)
//    }

    
    
    
    
    
    
    
    
    
    // MARK: - Rooms 정보
    /// Room의 개수
    var getNumOfRooms: Int {
        return self.roomsCellViewModels.count
    }
    /// MainCollectionViewCellVMProtocol 리턴
    func getRoomsViewModel(index: Int) -> MainCollectionViewCellVMProtocol {
        return self.roomsCellViewModels[index]
    }
    
    /// 현재 방 저장
    func saveCurrentRooms(
        index: Int,
        completion: @escaping (Result<Void, ErrorEnum>) -> ())
    {
        // 배열 범위 검사
        guard index >= 0, index < self.roomsCellViewModels.count else {
            completion(.failure(.readError))
            return
        }
        // 인덱스로부터 뷰모델 가져오기
        let viewModel = self.roomsCellViewModels[index]
        // currentRoom 설정
        self.currentRoom = (roomID: viewModel.getRoomID,
                            room: viewModel.getRoom)
        self.startLoadRoomData(completion: completion)
    }
    
    /// 방의 이름
    var getCurrentRoomName: String? {
        let currentRoom = self.currentRoom?.room
        return currentRoom?.roomName
    }
    
    /// 방 ID 리턴
    var getCurrentRoomsID: String? {
        return self.currentRoom?.roomID
    }

    /// 버전 ID 리턴
    var getCurrentVersion: String? {
        return self.currentRoom?.room.versionID
    }
    
    
    var checkIsRoomManager: Bool {
        guard let myUid = self.roomsAPI.getCurrentUserID,
              let roomManager = self.currentRoom?.room.roomManager 
        else {
            return false
        }
        return myUid == roomManager
    }
    
    
    
    
    
    
    // MARK: - 영수증 정보
    /// 영수증 개수
    var getNumOfReceipts: Int {
        return self.receiptCellViewModels.count
    }
    /// 영수증 셀(ReceiptTableViewCellVMProtocol) 리턴
    func getReceiptViewModel(index: Int) -> ReceiptTableViewCellVMProtocol {
        var receiptVM = self.receiptCellViewModels[index]
        
        let updatedReceipt = self.updateReceiptUserName(receipt: receiptVM.getReceipt)
        receiptVM.setReceipt(updatedReceipt)
        
        return receiptVM
    }
    /// index를 받아 알맞는 영수증을 리턴
    func getReceipt(at index: Int) -> Receipt {
        return self.receiptCellViewModels[index].getReceipt
    }
    
    func updateReceiptUserName(receipt: Receipt) -> Receipt {
        let payerUser = self.getIdToRoomUser(usersID: receipt.payer)
        var returndReceipt = receipt
            returndReceipt.updatePayerName(with: payerUser)
        return returndReceipt
    }
}



enum DataChangeEvent<T> {
    case added(T)
    case removed(String)
    case updated([String: [String: Any]])
    
    case initialLoad(T)
}

enum NotificationInfoString {
    case updated
    case added
    case removed
    case initialLoad
    case error
    
    var notificationName: String {
        switch self {
        case .initialLoad:  return "initialLoad"
        case .added:        return "added"
        case .removed:      return "removed"
        case .updated:      return "updated"
        case .error:        return "error"
        }
    }
}
// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)
extension Notification.Name {
    static let numberOfUsersChanges = Notification.Name("numberOfUsersChanges")
    static let receiptDataChanged = Notification.Name("receiptDataChanged")
    static let roomDataChanged = Notification.Name("roomDataChanged")
    static let userDataChanged = Notification.Name("userDataChanged")
    static let financialDataUpdated = Notification.Name("financialDataUpdated")
}
