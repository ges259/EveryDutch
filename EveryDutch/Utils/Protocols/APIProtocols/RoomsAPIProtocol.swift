//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol {
    static var shared: RoomsAPI { get }
    
    typealias RoomsIDCompletion = (Result<[Rooms], ErrorEnum>) -> Void
    typealias RoomUsersCompletion = (Result<[String: RoomUsers], ErrorEnum>) -> Void
    typealias RoomMoneyDataCompletion = (Result<CumulativeAmountDictionary, ErrorEnum>) -> Void
    
    
    func readRooms(completion: @escaping RoomsIDCompletion)
    func readRoomUsers(roomID: String, completion: @escaping RoomUsersCompletion)
    func readCumulativeAmount(completion: @escaping RoomMoneyDataCompletion)
}
