//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

enum DebounceType {
    case userData
    case roomData
    case receiptData
    
    var queue: DispatchQueue {
        switch self {
        case .userData:
            return DispatchQueue(label: "user-data-queue", qos: .userInitiated)
        case .roomData:
            return DispatchQueue(label: "room-data-queue", qos: .userInitiated)
        case .receiptData:
            return DispatchQueue(label: "receipt-data-queue", qos: .userInitiated)
        }
    }
    
    var notificationName: Notification.Name {
        switch self {
        case .userData:
            return .userDataChanged
        case .roomData:
            return .roomDataChanged
        case .receiptData:
            return .receiptDataChanged
            
        }
    }
    
    var interval: CGFloat {
        switch self {
        case .userData:
            return 0.7
        case .roomData:
            return 1
        case .receiptData:
            return 0.3
        }
    }
}


final class Debouncer {
    // MARK: - 프로퍼티
    // 기본 프로퍼티
    private let queue: DispatchQueue
    private let interval: CGFloat
    private let notificationName: Notification.Name
    // 인덱스패스 관련 프로퍼티
    private var workItem: DispatchWorkItem?
    private var indexPaths: [String: [IndexPath]] = [:]
    private var error: ErrorEnum?
    
    
    
    // MARK: - 라이프사이클
    init(_ type: DebounceType) {
        self.queue = type.queue
        self.interval = type.interval
        self.notificationName = type.notificationName
    }
    
    
    
    // MARK: - 디바운스 설정
    /// 인덱스패스를 저장 후, 디바운스를 설정하는 메서드
    func triggerDebounceWithIndexPaths(
        eventType: DataChangeType, 
        _ indexPaths: [IndexPath] = []
    ) {
        // 디바운스 취소
        self.cancelScheduledWork()
        // 인덱스패스 업데이트
        self.addIndexPaths(eventType: eventType, indexPaths: indexPaths)
        // 에러 정보 초기화
        self.error = nil
        // 디바운스
        self.debounce()
    }
    /// 인덱스패스를 저장하는 메서드
    private func addIndexPaths(
        eventType: DataChangeType, 
        indexPaths: [IndexPath]
    ) {
        let notiName = eventType.notificationName
        
        if self.indexPaths[notiName] == nil {
            self.indexPaths[notiName] = []
        }
        
        for indexPath in indexPaths {
            if let existingIndexPaths = self.indexPaths[notiName], !existingIndexPaths.contains(indexPath) {
                self.indexPaths[notiName]?.append(indexPath)
            }
        }
    }
    /// 디바운스를 설정하는 메서드
    private func debounce() {
        // 일정 시간이 지난 후, 동작할 행동 설정
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            print(#function)
            self.postNotification()
        }
        // 행동 저장
        self.workItem = newWorkItem
        // 디바운스 설정
        self.queue.asyncAfter(deadline: .now() + self.interval, execute: newWorkItem)
    }
    
    // MARK: - 에러 디바운스
    /// 인덱스패스를 삭제후, 디바운스를 통해 에러를 post하도록 설정하는 메서드
    func triggerErrorDebounce(_ errorType: ErrorEnum) {
        // 디바운스 취소
        self.cancelScheduledWork()
        // 에러 설정
        self.error = errorType
        // 업데이트하지 않음
        self.indexPaths = [:]
        // 디바운스 설정
        self.debounce()
    }
    
    // MARK: - 노티피케이션 post
    private func postNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // 노티피케이션 post
            NotificationCenter.default.post(
                name: self.notificationName,
                object: nil,
                userInfo: self.getUserInfoData)
            // 데이터를 초기화
            self.reset()
        }
    }
    
    private var getUserInfoData: [String: Any] {
        return self.error != nil
            ? ["error": self.error ?? .unknownError]
            : self.indexPaths
    }
    
    // MARK: - 데이터 초기화
    /// 디바운스 취소, 인덱스패스 및 에러 데이터 초기화
    func reset() {
        self.cancelScheduledWork()
        self.indexPaths = [:]
        self.error = nil
    }
    private func cancelScheduledWork() {
        self.workItem?.cancel()
    }
}




















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
    
    
    
    
    
    // MARK: - RoomUsrs
    /// [userID : User]로 이루어진 딕셔너리
    /// Receipt관련 화면에서 userID로 User의 데이터 사용
    /// ReceiptWriteVC에서 유저의 정보 사용
    var roomUserDataDict = [String : User]()
    // UsersTableViewCell 관련 프로퍼티들
    // [UsersID : IndexPath]
    var userIDToIndexPathMap = [String: IndexPath]()
    var usersCellViewModels = [UsersTableViewCellVMProtocol]()
    
    
    
    
    
    // MARK: - Receipt
    /// 영수증 배열
    var receiptIDToIndexPathMap = [String: IndexPath]()
    /// 영수증 테이블 셀의 뷰모델
    var receiptCellViewModels = [ReceiptTableViewCellVMProtocol]()
    
    
    
    
    
    // MARK: - 디바운서
    let userDebouncer = Debouncer(.userData)
    let roomDebouncer = Debouncer(.roomData)
    let receiptDebouncer = Debouncer(.receiptData)

    
    
    
    
    
    
    // MARK: - 플래그
    /// [플래그] RoomUsers 데이터 observe를 설정했는지 판단하는 변수
    var roomUsersInitialLoad: Bool = true
    /// [플래그] Receipt 데이터 observe를 설정했는지 판단하는 변수
    var receiptInitialLoad = true
    /// [플래그] Receipt 데이터를 추가적으로 가져올 지에 대한 플래그
    var hasMoreReceiptData: Bool = true
    
    
    
    
    
    
    
    
    
    
    // MARK: - 정산방 초기 데이터 로드
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
    
    
    
    
    
    
    // MARK: - 초기화
    /// RoomUsers / User에 대한 observer를 삭제하는 메서드
    func removeRoomsUsersObserver() {
        // 옵저버 삭제
        self.roomsAPI.removeRoomUsersAndUserObserver()
        // Receipt(영수증) 키 삭제
        self.receiptAPI.resetReceiptLastKey()
        // 정산방에 대한 데이터 삭제
        self.resetSettleMoneyRoomData()
    }
    func resetSettleMoneyRoomData() {
        // 플래그 데이터 초기화
        self.receiptInitialLoad = true
        self.roomUsersInitialLoad = true
        self.hasMoreReceiptData = true
        // 디바운싱 초기화
        self.userDebouncer.reset()
        self.receiptDebouncer.reset()
        
        // RoomUsers 데이터 초기화
        self.roomUserDataDict = [:]
        self.userIDToIndexPathMap = [:]
        self.usersCellViewModels = []
        // Receipt 데이터 초기화
        self.receiptIDToIndexPathMap = [:]
        self.receiptCellViewModels = []
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

enum DataChangeType {
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
}
