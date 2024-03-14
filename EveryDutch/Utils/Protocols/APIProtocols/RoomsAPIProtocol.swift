//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol: EditScreenAPIType {
    
    

    
    func readRoomsID(completion: @escaping Typealias.RoomsIDCompletion)
    func readRoomUsers(roomID: String, completion: @escaping Typealias.RoomUsersCompletion)
    func readCumulativeAmount(
        versionID: String,
        completion: @escaping Typealias.RoomMoneyDataCompletion)
    func readPayback(
        versionID: String,
        completion: @escaping Typealias.PaybackCompletion)
}
