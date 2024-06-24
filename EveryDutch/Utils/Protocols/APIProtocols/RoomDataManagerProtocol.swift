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
    func getRoomsViewModel(index: Int) -> MainCollectionViewCellVMProtocol
    
    func saveCurrentRooms(
        index: Int,
        completion: @escaping (Result<Void, ErrorEnum>) -> ())
    var getCurrentRoomsID: String? { get }
    var getCurrentVersion: String? { get }
    var getCurrentRoomName: String? { get }
    // API
    func loadRooms()
    
    
    
    
    // MARK: - RoomUsers
    var getNumOfRoomUsers: Int { get }
    var getRoomUsersDict: RoomUserDataDict { get }
    func getIndexToUsersVM(index: Int) -> UsersTableViewCellVMProtocol
    func getIdToUser(usersID: String) -> User?
    func removeRoomsUsersObserver()
    func selectUser(
        index: Int,
        completion: @escaping Typealias.VoidCompletion
    )
    
    var getCurrentUserData: UserDecoTuple? { get }
    var getCurrentUserID: String? { get }
    var currentUserIsEuqualToMyUid: Bool { get }
    
    // MARK: - Receipt
//    var getNumOfRoomReceipts: Int { get }
    
    var getNumOfRoomReceiptsSection: Int { get }
    
    func getNumOfRoomReceipts(section: Int) -> Int
    func updateReceiptUserName(receipt: Receipt) -> Receipt
    // API
    func loadMoreRoomReceipt()
    func getReceiptSectionDate(section: Int) -> String
    
    
//    func getRoomReceipt(at index: Int) -> Receipt
//    func getReceiptViewModel(index: Int) -> ReceiptTableViewCellVMProtocol
    func getReceiptViewModel(indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol
    func getRoomReceipt(at indexPath: IndexPath) -> Receipt
    
    
    
    
//    func fetchDecoration(userID: String) async throws -> Decoration?
//    func getIndexToUserDataTuple(index: Int) -> UserDataTuple 
    // MARK: - Fix
    func getUserIDToUsersVM(userID: String) -> UsersTableViewCellVMProtocol?
    
    
    
    func deleteUserFromRoom(
        isDeletingSelf: Bool,
        completion: @escaping Typealias.VoidCompletion
    )
    
    
    
}
