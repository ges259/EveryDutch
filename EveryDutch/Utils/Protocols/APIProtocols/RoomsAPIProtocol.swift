//
//  RoomsAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol RoomsAPIProtocol: EditScreenAPIType {
    static var shared: RoomsAPIProtocol { get }
    

    
    func readRoomsID(completion: @escaping Typealias.RoomsIDCompletion)
    func readRoomUsers(roomID: String, completion: @escaping Typealias.RoomUsersCompletion)
    func readCumulativeAmount(completion: @escaping Typealias.RoomMoneyDataCompletion)
    func readPayback(completion: @escaping Typealias.PaybackCompletion)
}
