//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

typealias RoomUserDataDictionary = [String : RoomUsers]
typealias CumulativeAmountDictionary = [String : CumulativeAmount]



final class RoomDataManager: RoomDataManagerProtocol {
    static let shared: RoomDataManagerProtocol = RoomDataManager(
        roomsAPI: RoomsAPI.shared)
    
    
    var roomsAPI: RoomsAPIProtocol
    
    
    // MARK: - 라이프사이클
    init(roomsAPI: RoomsAPIProtocol) {
        self.roomsAPI = roomsAPI
    }
    
    
    
    
    /// roomID / versionID / roomNam / roomImg
    private var roomData: Rooms?
    private var rooms: [Rooms]?
    private var currentIndex: Int = 0
    
    private var roomUserDataDict: RoomUserDataDictionary = [:]
    private var cumulativeAmount: CumulativeAmountDictionary = [:]
    
    private var paybackData: Payback?
    
    
    
    
    // MARK: - 방의 개수
    var getNumOfRoomUsers: Int {
        return Array(self.roomUserDataDict.values).count
    }
    
    // MARK: - 방의 유저 데이터
    var getRoomUsersDict: RoomUserDataDictionary {
        return self.roomUserDataDict
    }
    
    // MARK: - 방의 이름
    var getRoomName: String? {
        return self.roomData?.roomID
    }
    
    
    
    
// MARK: - 특정 유저의 정보 리턴
    
    
    
    // MARK: - 유저의 누적 금액 리턴
    func getIDToCumulativeAmount(userID: String) -> Int {
        return self.cumulativeAmount[userID]?.cumulativeAmount ?? 0
    }
    
    // MARK: - 유저의 정보 리턴
    func getIdToRoomUser(usersID: String) -> RoomUsers {
        return self.roomUserDataDict[usersID]
        ?? RoomUsers(dictionary: [:])
    }
    
    // MARK: - 유저의 페이백 값 리턴
    func getIDToPayback(userID: String) -> Int {
        return self.paybackData?.payback[userID] ?? 0
    }
    
    
    
    
    
    
    
    
    // MARK: - [API] 유저 데이터
    // 콜백 함수 만들기(completion)
    // SettlementMoneyRoomVM에서 호출 됨
    func loadRoomUsers(
        roomData: Rooms,
        completion: @escaping (RoomUserDataDictionary) -> Void)
    {
        // roomData 저장
        self.roomData = roomData
        
        // 데이터베이스나 네트워크에서 RoomUser 데이터를 가져오는 로직
        self.roomsAPI.readRoomUsers(
            roomID: roomData.roomID) { result in
                switch result {
                case .success(let users):
                    // [String : RoomUsers] 딕셔너리 저장
                    self.roomUserDataDict = users
                    completion(users)
                    break
                    // MARK: - Fix
                case .failure(_): break
                }
            }
    }
    
    // MARK: - [API] 누적 금액 데이터
    func loadCumulativeAmountData(
        completion: @escaping () -> Void)
    {
        self.roomsAPI.readCumulativeAmount { data in
            switch data {
            case .success(let moneyData):
                self.cumulativeAmount = moneyData
                completion()
            // MARK: - Fix
            case .failure(_): break
            }
        }
    }
    
    // MARK: - [API] 페이백 데이터
    func loadPaybackData(completion: @escaping () -> Void) {
        self.roomsAPI.readPayback { paybackData in
            switch paybackData {
            case .success(let data):
                self.paybackData = data
                self.loadCumulativeAmountData {
                    completion()
                }
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
    }
    
    
    // MARK: - [API] 방의 데이터
    func loadRooms(completion: @escaping () -> Void) {
        self.roomsAPI.readRooms { result in
            switch result {
            case .success(let rooms):
                self.rooms = rooms
                completion()
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
    }
}
