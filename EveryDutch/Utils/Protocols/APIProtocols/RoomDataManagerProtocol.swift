//
//  RoomDataManagerProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation


protocol RoomDataManagerProtocol {
    static var shared: RoomDataManagerProtocol { get }
    
    var getCurrentRoomsID: String? { get }
    var getCurrentVersion: String? { get }
    
    
    var getNumOfRoomUsers: Int { get }
    func saveCurrentRooms(index: Int)
    var getRooms: [Rooms] { get }
    
    var getRoomUsersDict: RoomUserDataDict { get }
    var getCurrentRoomName: String? { get }
//    var getCumulativeAmountArray: CumulativeAmountDictionary { get }
    
    func getIdToRoomUser(usersID: String) -> User
    func getIDToPayback(userID: String) -> Int

    func getIDToCumulativeAmount(userID: String) -> Int
    
    func loadRoomUsers(
        completion: @escaping (RoomUserDataDict) -> Void)
    
    func loadCumulativeAmountData(
        completion: @escaping () -> Void) 
    func loadPaybackData(completion: @escaping () -> Void)
    
    func loadRooms(completion: @escaping () -> Void)
}
