//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit



final class RoomDataManager: RoomDataManagerProtocol {
    static let shared: RoomDataManagerProtocol = RoomDataManager(
        roomsAPI: RoomsAPI.shared)
    
    
    var roomsAPI: RoomsAPIProtocol
    
    
    // MARK: - 라이프사이클
    init(roomsAPI: RoomsAPIProtocol) {
        self.roomsAPI = roomsAPI
    }
    
    
    
    
    /// roomID / versionID / roomNam / roomImg
    private var currentRoomData: Rooms?
    
    
    private var rooms: [Rooms]?
    private var currentIndex: Int = 0
    
    private var roomUserDataDict: RoomUserDataDict = [:]
    private var cumulativeAmount: CumulativeAmountDictionary = [:]
    
    private var paybackData: Payback?
    
    


    
    // MARK: - 방의 개수
    var getNumOfRoomUsers: Int {
        return Array(self.roomUserDataDict.values).count
    }
    

    
    // MARK: - 방의 유저 데이터
    var getRoomUsersDict: RoomUserDataDict {
        return self.roomUserDataDict
    }
    
    // MARK: - 방 데이터 가져가기
    var getRooms: [Rooms] {
        guard let rooms = self.rooms else { return [] }
        return rooms
    }
    
    
    
    
    
    
    
// MARK: - 현재 방 정보

    
    
    // MARK: - 선택된 현재 방 저장
    func saveCurrentRooms(index: Int) {
        self.currentRoomData = self.rooms?[index]
    }
    
    // MARK: - 방의 이름
    var getCurrentRoomName: String? {
        return self.currentRoomData?.roomID
    }
    
    // MARK: - 방 ID
    var getCurrentRoomsID: String? {
        return self.currentRoomData?.roomID
    }
    
    // MARK: - 버전 ID
    var getCurrentVersion: String? {
        return self.currentRoomData?.versionID
    }
    
    
    
    
    
// MARK: - 특정 유저 정보 리턴
    
    
    
    // MARK: - 누적 금액
    func getIDToCumulativeAmount(userID: String) -> Int {
        return self.cumulativeAmount[userID]?.cumulativeAmount ?? 0
    }
    
    // MARK: - RoomUsers 정보
    func getIdToRoomUser(usersID: String) -> User {
        return self.roomUserDataDict[usersID]
        ?? User(dictionary: [:])
    }
    
    // MARK: - 페이백 값
    func getIDToPayback(userID: String) -> Int {
        return self.paybackData?.payback[userID] ?? 0
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - [API] 유저 데이터
    // 콜백 함수 만들기(completion)
    // SettlementMoneyRoomVM에서 호출 됨
    func loadRoomUsers(
        completion: @escaping (RoomUserDataDict) -> Void)
    {
        // roomData 저장
        guard let roomID = self.currentRoomData?.roomID else { return }
        
        // 데이터베이스나 네트워크에서 RoomUser 데이터를 가져오는 로직
        self.roomsAPI.readRoomUsers(
            roomID: roomID) { [weak self] result in
                switch result {
                case .success(let users):
                    print("users 성공")
                    // [String : RoomUsers] 딕셔너리 저장
                    self?.roomUserDataDict = users
                    completion(users)
                    break
                    // MARK: - Fix
                case .failure(_):
                    print("users 실패")
                    break
                }
            }
    }
    
    // MARK: - [API] 누적 금액 데이터
    func loadCumulativeAmountData(
        completion: @escaping () -> Void)
    {
        self.roomsAPI.readCumulativeAmount { [weak self] data in
            switch data {
            case .success(let moneyData):
                print("cumulativeMoney 성공")
                self?.cumulativeAmount = moneyData
                completion()
            // MARK: - Fix
            case .failure(_):
                print("cumulativeMoney 실패")
                completion()
                break
            }
        }
    }
    
    // MARK: - [API] 페이백 데이터
    func loadPaybackData(completion: @escaping () -> Void) {
        self.roomsAPI.readPayback { [weak self] paybackData in
            switch paybackData {
            case .success(let data):
                print("payback 성공")
                self?.paybackData = data
                self?.loadCumulativeAmountData {
                    print("cumulativeMoney 성공")
                    completion()
                }
                break
                // MARK: - Fix
            case .failure(_):
                self?.loadCumulativeAmountData {
                    print("cumulativeMoney 실패")
                    completion()
                }
                print("payback 실패")
                break
            }
        }
    }
    
    
    // MARK: - [API] 방의 데이터
    func loadRooms(completion: @escaping () -> Void) {
        
        self.roomsAPI.readRoomsID {[weak self] result in
            switch result {
            case .success(let rooms):
                self?.rooms = rooms
                print("loadRooms 성공")
                completion()
                break
                // MARK: - Fix
            case .failure(_):
                print("loadRooms 실패")
                break
            }
        }
    }
}
