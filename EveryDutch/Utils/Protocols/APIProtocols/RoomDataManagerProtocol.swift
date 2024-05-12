//
//  RoomDataManagerProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation


protocol RoomDataManagerProtocol {
    
    
    func startLoadRoomData()
    func loadReceipt()
    
    
    // MARK: - Rooms
    var getNumOfRooms: Int { get }
    func getRoomsViewModel(index: Int) -> MainCollectionViewCellVMProtocol
    
    
    func saveCurrentRooms(index: Int)
    var getCurrentRoomsID: String? { get }
    var getCurrentVersion: String? { get }
    var getCurrentRoomName: String? { get }
    
    
    
    // MARK: - RoomUsers
    
    
    var getNumOfRoomUsers: Int { get }
    func getUsersViewModel(index: Int) -> UsersTableViewCellVMProtocol
    var getRoomUsersDict: RoomUserDataDict { get }
    func getIdToRoomUser(usersID: String) -> User
    func removeRoomsUsersObserver()
    
    
    
    
    // MARK: - Receipt
    
    // MARK: - 영수증 정보
    var NumOfReceipts: Int { get }
    func getReceiptViewModel(index: Int) -> ReceiptTableViewCellVMProtocol
    
    
    
    
    
    // MARK: - API
    func loadFinancialData()
    
    
    func loadRoomUsers(completion: @escaping (Result<Void, ErrorEnum>) -> Void)
    func loadRooms(completion: @escaping Typealias.VoidCompletion)
}
