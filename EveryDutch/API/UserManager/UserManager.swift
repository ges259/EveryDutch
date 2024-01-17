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
    static let shared: RoomDataManager = RoomDataManager()
    private init() {}
    
    /// roomID / versionID / roomNam / roomImg
    private var roomData: Rooms?
    
    private var roomUserDataDict: RoomUserDataDictionary = [:]
    private var cumulativeAmount: CumulativeAmountDictionary = [:]
    
    private var paybackData: Payback?
    
    
    
    
    
    var getNumOfRoomUsers: Int {
        return Array(self.roomUserDataDict.values).count
    }
    
    var getRoomUsersDict: RoomUserDataDictionary {
        return self.roomUserDataDict
    }
    var getRoomName: String? {
        return self.roomData?.roomID
    }
    
    
    
    
    
    
    func getIDToCumulativeAmount(userID: String) -> Int {
        return self.cumulativeAmount[userID]?.cumulativeAmount ?? 0
    }
    
    func getIdToRoomUser(usersID: String) -> RoomUsers {
        return self.roomUserDataDict[usersID]
        ?? RoomUsers(dictionary: [:])
    }
    
    func getIDToPayback(userID: String) -> Int {
        return self.paybackData?.payback[userID] ?? 0
    }
    
    
    
    
    
    
    
    
    // MARK: - 유저 데이터 가져오기
    // 콜백 함수 만들기(completion)
    // SettlementMoneyRoomVM에서 호출 됨
    func loadRoomUsers(
        roomData: Rooms,
        completion: @escaping (RoomUserDataDictionary) -> Void)
    {
        // roomData 저장
        self.roomData = roomData
        
        // 데이터베이스나 네트워크에서 RoomUser 데이터를 가져오는 로직
        RoomsAPI.shared.readRoomUsers(
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
    
    
    func loadCumulativeAmountData(
        completion: @escaping () -> Void)
    {
        RoomsAPI.shared.readCumulativeAmount { data in
            switch data {
            case .success(let moneyData):
                self.cumulativeAmount = moneyData
                completion()
            // MARK: - Fix
            case .failure(_): break
            }
        }
    }
    
    func loadPaybackData(completion: @escaping () -> Void) {
        RoomsAPI.shared.readPayback { paybackData in
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
}
