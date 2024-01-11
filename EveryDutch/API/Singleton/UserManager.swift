//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

final class RoomDataManager {
    static let shared: RoomDataManager = RoomDataManager()
    private init() {}
    
    /// personalID / roomName / roomImg
    private var roomUsers: [RoomUsers] = []
    /// roomID / versionID / roomNam / roomImg
    private var roomData: Rooms?
    
    
    var getRoomUsers: [RoomUsers] {
        return self.roomUsers
    }
    
    func getUserNameAndImg(user: [String]) {
        // ID를 받음
        
        // forEach 사용
        // ID에 맞는 이름 및 이미지를 가져옴
        
        // [ID    : (이름   , 이미지)]
        // [String: (String, String)]으로 리턴
        
    }

    
    
    
    // MARK: - 유저 데이터 가져오기
    // 콜백 함수 만들기(completion)
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
                    // roomUsers 저장
                    self.roomUsers = users
                    completion(users)
                    break
                    // MARK: - Fix
                case .failure(_): break
                }
            }
    }
    
    

    
    
    
}
