//
//  RoomDataManagerProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation


protocol RoomDataManagerProtocol {
    func getViewModel(index: Int) -> UsersTableViewCellVMProtocol
    
    
    var getRoomUsersDict: RoomUserDataDict { get }
    
    
    
    var getCurrentRoomsID: String? { get }
    var getCurrentVersion: String? { get }
    
    
    var getNumOfRoomUsers: Int { get }
    func saveCurrentRooms(index: Int)
    var getRooms: [Rooms] { get }
    
    
    var getCurrentRoomName: String? { get }
//    var getCumulativeAmountArray: CumulativeAmountDictionary { get }
    
    func getIdToRoomUser(usersID: String) -> User
    func getIDToPayback(userID: String) -> Int

    func getIDToCumulativeAmount(userID: String) -> Int
    
    
    func loadFinancialData(completion: @escaping Typealias.VoidCompletion)
    
    func loadRoomUsers(
        completion: @escaping Typealias.VoidCompletion)
    
//    func loadCumulativeAmountData(
//        completion: @escaping Typealias.VoidCompletion) 
//    func loadPaybackData(completion: @escaping Typealias.VoidCompletion)
    
    func loadRooms(completion: @escaping Typealias.VoidCompletion)
    
    
    
    func addedRoom(room: Rooms) 
}
