//
//  RoomDataManagerProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation


protocol RoomDataManagerProtocol {
    static var shared: RoomDataManager { get }
    
    var getNumOfRoomUsers: Int { get }
    
    var getRoomUsersDict: RoomUserDataDictionary { get }
    
    var getCumulativeAmountArray: [CumulativeAmount] { get }
    
    func getIdToRoomUser(usersID: String) -> RoomUsers
    func getIDToPayback(userID: String) -> Int
    
    
    func loadRoomUsers(
        roomData: Rooms,
        completion: @escaping (RoomUserDataDictionary) -> Void)
    
    func loadCumulativeAmountData(
        completion: @escaping () -> Void) 
    func loadPaybackData(completion: @escaping () -> Void)
}
