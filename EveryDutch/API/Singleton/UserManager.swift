//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

typealias RoomUserDataDictionary = [String : RoomUsers]

final class RoomDataManager {
    static let shared: RoomDataManager = RoomDataManager()
    private init() {}
    
    /// personalID / roomName / roomImg
//    private var roomUsers: [RoomUsers] = []
    /// roomID / versionID / roomNam / roomImg
    private var roomData: Rooms?
    
    var userIDs: [String: RoomUsers] = [:]
    
    
    var numOfRoomUsers: Int {
        return Array(self.userIDs.values).count
    }
    
    
    func getIdToroomUser(usersID: String) -> RoomUsers {
        return self.userIDs[usersID] ?? RoomUsers(userID: "",
                                                  dictionary: [:])
    }
    
    var getRoomUsers: [RoomUsers] {
        return Array(self.userIDs.values)
    }
    
    // MARK: - 유저 데이터 가져오기
    // 콜백 함수 만들기(completion)
    // SettlementMoneyRoomVM에서 호출 됨
    
    func loadRoomUsers(
        roomData: Rooms,
        completion: @escaping ([RoomUsers]) -> Void) 
    {
        // roomData 저장
        self.roomData = roomData
        
        // 데이터베이스나 네트워크에서 RoomUser 데이터를 가져오는 로직
        RoomsAPI.shared.readRoomUsers(
            roomID: roomData.roomID) { result in
                switch result {
                case .success(let users):
                    // [roomUsers] 배열 저장
//                    self.roomUsers = Array(users.values)
                    // [String : RoomUsers] 딕셔너리 저장
                    self.userIDs = users
                    completion(Array(users.values))
                    break
                    // MARK: - Fix
                case .failure(_): break
                }
            }
    }
    
    
    
    
    
    
    
    
    
}
