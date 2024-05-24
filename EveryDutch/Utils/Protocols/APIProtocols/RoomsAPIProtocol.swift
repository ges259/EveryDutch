//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol: EditScreenAPIType {
    
    // 개별 사용자의 데이터 변경을 관찰하는 함수
    func setRoomObserver(completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    
    
    
    
    
    func roomUsersObserver(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)
    
    func readRooms(completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    
    
    
    func readRoomUsers(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)

    
    
    func readCumulativeAmount(
        versionID: String,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    
    func readPayback(
        versionID: String,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    
    
    func updateNewMember(
        userID: String,
        roomID: String,
        versionID: String) async throws
    
    
    func removeRoomUsersAndUserObserver()
    
    
    
    
    
    func setRoomsDataObserver(
        roomIDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
}
