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

    var numOfRoomUsers: Int {
        return self.roomUsers.count
    }
    
    
    
    typealias NameAndImgCompeltion = [String: (name: String, img: String)]
                                      
    // MARK: - 유저 이름과 이미지 가져오기
    // ID 배열을 받음
    func getUserNameAndImg(userIDs: [String]) -> NameAndImgCompeltion {
        // 리턴할 값의 타입 배열 설정
        // [String: (String, String)]
        var userInfoDict = [String: (name: String, img: String)]()
        // forEach 사용
        userIDs.forEach { id in
            // ID에 맞는 이름 및 이미지를 가져옴
            if let user = roomUsers.first(where: { $0.userID == id }) {
                userInfoDict[id] = (name: user.roomName, img: user.roomImg)
            }
        }
        // [ID : (이름 , 이미지)] 으로 리턴
        return userInfoDict
    }
    
    // PaymentDetail에 이름과 이미지를 추가하는 함수
    func updatePaymentDetails(paymentDetails: [PaymentDetail]) -> [PaymentDetail] {
        var updatedPaymentDetails = paymentDetails
        for (index, detail) in paymentDetails.enumerated() {
            if let roomUser = roomUsers.first(where: { $0.userID == detail.userID }) {
                updatedPaymentDetails[index].userName = roomUser.roomName
                updatedPaymentDetails[index].userImg = roomUser.roomImg
            }
        }
        return updatedPaymentDetails
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
