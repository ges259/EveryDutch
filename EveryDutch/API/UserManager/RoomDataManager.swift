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
    
    
    
    
    
    // MARK: - RoomUsrs
    var currentUser: (userID: String,
                      user: User,
                      deco: Decoration?)?
    // UsersTableViewCell 관련 프로퍼티들
    // [UsersID : IndexPath]
    var userIDToIndexPathMap = [String: IndexPath]()
    var usersCellViewModels = [UsersTableViewCellVMProtocol]()
    
    
    
    
    
    // MARK: - Receipt
    /// 영수증 배열
    var receiptIDToIndexPathMap = [String: IndexPath]()
    /// 영수증 테이블 셀의 뷰모델
//    var roomReceiptCellViewModels = [ReceiptTableViewCellVMProtocol]()
    var receiptSections = [ReceiptSection]()
    
    
    
    // MARK: - 디바운서
    let userDebouncer = Debouncer(.userData)
    let roomDebouncer = Debouncer(.roomData)
    let receiptDebouncer = Debouncer(.receiptData)
    
    
    
    
    
    
    
    // MARK: - 플래그
    /// [플래그] RoomUsers 데이터 observe를 설정했는지 판단하는 변수
    var roomUsersInitialLoad: Bool = true
    /// [플래그] Receipt 데이터 observe를 설정했는지 판단하는 변수
    var roomReceiptInitialLoad = false
    /// [플래그] Receipt 데이터를 추가적으로 가져올 지에 대한 플래그
    var hasMoreRoomReceiptData: Bool = true

    
    
    
    
    
    
    
    
    
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
                self.loadRoomReceipt(completion: completion)
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
        self.roomReceiptInitialLoad = false
        self.roomUsersInitialLoad = true
        self.hasMoreRoomReceiptData = true
        // 디바운싱 초기화
        self.userDebouncer.reset()
        self.receiptDebouncer.reset()
        
        // RoomUsers 데이터 초기화
        self.userIDToIndexPathMap = [:]
        self.usersCellViewModels = []
        // Receipt 데이터 초기화
        self.receiptIDToIndexPathMap = [:]
//        self.roomReceiptCellViewModels = []
        self.receiptSections = []
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - User 정보
    /// 방의 개수
    var getNumOfRoomUsers: Int {
        return self.usersCellViewModels.count
    }
    
    /// 모든 뷰모델 리턴
    func getIndexToUsersVM(index: Int) -> UsersTableViewCellVMProtocol {
        return self.usersCellViewModels[index]
    }
    
    /// userID에 해당하는 뷰모델을 리턴
    func getUserIDToUsersVM(userID: String) -> UsersTableViewCellVMProtocol? {
        // userIDToIndexPathMap에서 userID로 IndexPath를 찾습니다.
        guard let indexPath = userIDToIndexPathMap[userID] else {
            return nil  // userID가 존재하지 않을 경우 nil 반환
        }
        // IndexPath를 사용하여 usersCellViewModels에서 뷰모델을 찾습니다.
        let row = indexPath.row
        guard row < usersCellViewModels.count else {
            return nil  // IndexPath가 유효하지 않을 경우 nil 반환
        }
        return usersCellViewModels[row]
    }
    
    /// 특정 유저 정보 리턴
    var getRoomUsersDict: RoomUserDataDict {
        return usersCellViewModels.reduce(into: RoomUserDataDict()) { result, viewModel in
            result[viewModel.userID] = viewModel.getUser
        }
    }
    /// 유저 ID를 받으면, User를 리턴
    func getIdToUser(usersID: String) -> User? {
        let usersVM = self.getUserIDToUsersVM(userID: usersID)
        return usersVM?.getUser
    }
    
    /// userTableView에서 유저가 선택이 된다면, IndexPath.row를 파라미터로 받고,
    /// 해당 유저의 (User, Decoration) 튜플 데이터를 리턴
    func getIndexToUserDataTuple(index: Int) -> UserDataTuple {
        let viewModel = self.getIndexToUsersVM(index: index)
        
        return (key: viewModel.userID,
                value: viewModel.getUser)
    }
    
    
    /// userTableView에서 유저가 선택이 된다면, Decoration데이터를 가져옴
    func selectUser(
        index: Int,
        completion: @escaping Typealias.VoidCompletion
    ) {
        Task {
            do {
                let userTuple = self.getIndexToUserDataTuple(index: index)
                let deco = try await self.fetchDecoration(userID: userTuple.key)
                
                // 현재 유저 저장
                self.currentUser = (userID: userTuple.key,
                                    user: userTuple.value,
                                    deco: deco)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch let error as ErrorEnum {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.readError))
                }
            }
        }
    }
    /// 현재 선택된 유저의 UserDecoTuple (User , Decoration)
    var getCurrentUserData: UserDecoTuple? {
        guard let currentUser = currentUser else { return nil }
        
        return (user: currentUser.user,
                deco: currentUser.deco)
    }
    /// 현재 선택된 유저의 userID
    var getCurrentUserID: String? {
        return self.currentUser?.userID
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
    
    /// 현재 방의 이름
    var getCurrentRoomName: String? {
        let currentRoom = self.currentRoom?.room
        return currentRoom?.roomName
    }
    
    /// 현재 방 ID 리턴
    var getCurrentRoomsID: String? {
        return self.currentRoom?.roomID
    }
    
    /// 현재 버전 ID 리턴
    var getCurrentVersion: String? {
        return self.currentRoom?.room.versionID
    }
    
    /// 자신이 방장인지를 판단하는 변수
    var checkIsRoomManager: Bool {
        guard let myUid = self.roomsAPI.getCurrentUserID,
              let roomManager = self.currentRoom?.room.roomManager
        else {
            return false
        }
        return myUid == roomManager
    }
    
    var currentUserIsEuqualToMyUid: Bool {
        guard let currentUserID = self.currentUser?.userID,
              let uid = self.roomsAPI.getCurrentUserID,
              currentUserID != uid
        else {
            return false
        }
        return true
    }
    
    
    
    
    
    // MARK: - 영수증 정보
    /// 섹션의 개수
    var getNumOfRoomReceiptsSection: Int {
        return self.receiptSections.count
    }
    /// 영수증 개수
    func getNumOfRoomReceipts(section: Int) -> Int {
        return self.receiptSections[section].receipts.count
    }
    /// 섹션 헤더의 타이틀(날짜)를 리턴
    func getReceiptSectionDate(section: Int) -> String {
        self.receiptSections[section].date
    }
    /// 영수증 셀(ReceiptTableViewCellVMProtocol) 리턴
    func getReceiptViewModel(indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol {
        var receiptVM = self.receiptSections[indexPath.section].receipts[indexPath.row]
        
        let updatedReceipt = self.updateReceiptUserName(receipt: receiptVM.getReceipt)
        receiptVM.setReceipt(updatedReceipt)
        
        return receiptVM
    }
    /// index를 받아 알맞는 영수증을 리턴
    func getRoomReceipt(at indexPath: IndexPath) -> Receipt {
        return self.receiptSections[indexPath.section].receipts[indexPath.row].getReceipt
    }
    /// Receipt에 있는 payment_Detail의 userID를 userName으로 바꿈
    func updateReceiptUserName(receipt: Receipt) -> Receipt {
        let payerUser = self.getIdToUser(usersID: receipt.payer)
        var returndReceipt = receipt
        returndReceipt.updatePayerName(with: payerUser)
        return returndReceipt
    }
}
