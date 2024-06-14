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
    
    
    
    
    // MARK: - RoomUsers
    var getNumOfRoomUsers: Int { get }
    var getRoomUsersDict: RoomUserDataDict { get }
    func getIndexToUsersVM(index: Int) -> UsersTableViewCellVMProtocol
    func getIdToUser(usersID: String) -> User?
    func removeRoomsUsersObserver()
    // API
    func loadRooms()
    
    
    
    
    // MARK: - Receipt
    
    func updateSearchMode(searchMode: Bool)
    var getNumOfReceipts: Int { get }
    func getReceiptViewModel(index: Int) -> ReceiptTableViewCellVMProtocol
    func getReceipt(at index: Int) -> Receipt
    func updateReceiptUserName(receipt: Receipt) -> Receipt
    // API
    func loadMoreRoomReceipt()
    
    
    
    
    
    
    
    func fetchDecoration(userID: String) async throws -> Decoration? 
    func getIndexToUserDataTuple(index: Int) -> UserDataTuple 
    // MARK: - Fix
    func getUserIDToUsersVM(userID: String) -> UsersTableViewCellVMProtocol?
}
