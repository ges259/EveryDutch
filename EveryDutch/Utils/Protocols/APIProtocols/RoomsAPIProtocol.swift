//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol: EditScreenAPIType {
    
    
    
    func readRooms() async throws -> [Rooms]
    
    // *(((((
    func readRoomUsers(roomID: String, completion: @escaping Typealias.RoomUsersCompletion)
    
    
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
}
