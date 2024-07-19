//
//  RoomDataManagerProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation


protocol RoomDataManagerProtocol {
    var checkIsRoomManager: Bool { get }
    
    
    // MARK: - Rooms
    var getNumOfRooms: Int { get }
    func getRoomsViewModel(index: Int) -> MainCollectionViewCellVMProtocol?
    
    func saveCurrentRooms(index: Int)
    var getCurrentRoomsID: String? { get }
    var getCurrentVersion: String? { get }
    var getCurrentRoomName: String? { get }
    // API
    func loadRooms()
    
    
    
    
    // MARK: - RoomUsers
    var getNumOfRoomUsers: Int { get }
    var getRoomUsersDict: RoomUserDataDict { get }
    func getIndexToUsersVM(index: Int) -> UsersTableViewCellVMProtocol?
    func getIdToUser(usersID: String) -> User?
    func removeRoomsUsersObserver()
    func selectUser(
        index: Int,
        completion: @escaping Typealias.VoidCompletion
    )
    
    var getCurrentUserData: UserDecoTuple? { get }
    var getSelectedUserID: String? { get }
    var currentUserIsEuqualToMyUid: Bool { get }
    
    var myUserData: UserDecoTuple? { get }
    
    
    func getProviderTuple(isUser: Bool) -> ProviderTuple?
    
    
    /// 유저의 정보(User)가 존재하는지 확인 후, 가져온 데이터는 저장
    func checkMyUserDataIsExist() async throws
    
    
    
    
    
    
    
    
    // MARK: - Receipt
    var getNumOfRoomReceiptsSection: Int { get }
    func getNumOfRoomReceipts(section: Int) -> Int?
    func updateReceiptUserName(receipt: Receipt) -> Receipt
    func getRoomReceiptViewModel(indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol?
    func getRoomReceipt(at indexPath: IndexPath) -> Receipt?
    // API
    func loadMoreRoomReceipt()
    func getRoomReceiptSectionDate(section: Int) -> String?
    
    func loadUserReceipt()
    func loadMoreUserReceipt()
    
    
    
    /// 섹션의 개수
    var getNumOfUserReceiptsSection: Int { get }
    /// 영수증 개수
    func getNumOfUserReceipts(section: Int) -> Int?
    /// 섹션 헤더의 타이틀(날짜)를 리턴
    func getUserReceiptSectionDate(section: Int) -> String?
    /// 영수증 셀(ReceiptTableViewCellVMProtocol) 리턴
    func getUserReceiptViewModel(indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol?
    /// index를 받아 알맞는 영수증을 리턴
    func getUserReceipt(at indexPath: IndexPath) -> Receipt?
    
    
    
    
    
    
    
    // MARK: - Fix
    func getUserIDToUsersVM(userID: String) -> UsersTableViewCellVMProtocol?
    
    
    
    func deleteUserFromRoom(
        isDeletingSelf: Bool,
        isRoomManager: Bool,
        completion: @escaping Typealias.VoidCompletion
    )
    
    
    
    
    var myUserID: String? { get }
    
}
