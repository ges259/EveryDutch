//
//  RoomDataManagerProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation


protocol RoomDataManagerProtocol {
    static var shared: RoomDataManager { get }
    
    var numOfRoomUsers: Int { get }
    
    var getRoomUsersDict: RoomUserDataDictionary { get }
    
    var getRoomMoneyData: [MoneyData] { get }
    
    func getIdToroomUser(usersID: String) -> RoomUsers
    
    
    
    func loadRoomUsers(
        roomData: Rooms,
        completion: @escaping (RoomUserDataDictionary) -> Void)
    
    func loadRoomMoneyData(
        completion: @escaping ([MoneyData]) -> Void) 
}
