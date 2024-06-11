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
    func getAllOfUsersViewModel(index: Int) -> UsersTableViewCellVMProtocol
    func getIdToRoomUser(usersID: String) -> User?
    func removeRoomsUsersObserver()
    // API
    func loadRooms()
    
    
    
    
    // MARK: - Receipt
    var getNumOfReceipts: Int { get }
    func getReceiptViewModel(index: Int) -> ReceiptTableViewCellVMProtocol
    func getReceipt(at index: Int) -> Receipt
    func updateReceiptUserName(receipt: Receipt) -> Receipt
    // API
    func loadMoreReceiptData()
    
    
    
    
    
    
    
    // MARK: - Fix
    func getOneOfUsersViewModel(userID: String) -> UsersTableViewCellVMProtocol?
}
