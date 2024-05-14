//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol: EditScreenAPIType {
    
    // 개별 사용자의 데이터 변경을 관찰하는 함수
    func observerRoomsDataChanges(
        roomIDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    
//    func observeRoomAndUsers(
//        roomID: String,
//        userIDs: [String],
//        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)
//    
    func readRooms(completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
//    func readRooms() async throws -> [Rooms]
    
    // *(((((
    func readRoomUsers(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)

    
    
    func readCumulativeAmount(
        versionID: String,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    
    func readPayback(
        versionID: String,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    
    
//    func readRoomUsers(roomID: String) async throws -> [String : User]
//    func readCumulativeAmount(versionID: String) async throws -> [String : CumulativeAmount]
//    func readPayback(versionID: String) async throws -> Payback
    
    
    func updateNewMember(
        userID: String,
        roomID: String,
        versionID: String) async throws
    
    
    func removeRoomUsersAndUserObserver()
}
