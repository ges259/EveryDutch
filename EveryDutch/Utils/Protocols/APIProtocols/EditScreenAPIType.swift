//
//  EditScreenAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/6/24.
//

import Foundation

protocol EditScreenAPIType {
    func createData(dict: [String: Any]) async throws
    
    func updateData(dict: [String: Any])
}

//protocol RoomEditAPIType: EditScreenAPIType {
//    func createData(dict: [String: Any]) async throws -> Rooms
//    
//    func updateData(dict: [String: Any])
//}
//
//protocol ProfileEditAPIType: EditScreenAPIType {
//}
