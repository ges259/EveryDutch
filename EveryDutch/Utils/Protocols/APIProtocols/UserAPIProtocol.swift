//
//  UserAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol UserAPIProtocol: EditScreenAPIType {
    
    

    func readUser(uid: String, completion: @escaping Typealias.RoomUsersCompletion)
    
    func searchUser(
        _ userID: String,
        completion: @escaping Typealias.RoomUsersCompletion)
}
