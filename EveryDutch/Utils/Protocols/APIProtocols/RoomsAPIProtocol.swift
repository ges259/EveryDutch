//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol: EditScreenAPIType {
    
    
    var getMyUserID: String? { get }
    
    // 개별 사용자의 데이터 변경을 관찰하는 함수
    func setUserRoomsIDObserver(completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    
    
    
    
    
    func roomUsersObserver(
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
        roomID: String) async throws
    
    
    func removeRoomUsersAndUserObserver()
    func deleteUser(
        roomID: String,
        userID: String?,
        isRoomManager: Bool
    ) async throws
    
    func reportUser(
        roomID: String,
        reportedUserID: String,
        completion: @escaping (Result<Int, ErrorEnum>) -> Void
    )
    
}
