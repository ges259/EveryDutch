//
//  PeopleSelectionPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import Foundation


protocol PeopleSelectionPanVMProtocol {
    var roomDataManager: RoomDataManager { get }
    var users: RoomUserDataDictionary { get }
    var numOfUsers: Int { get }
    func selectedUser(index: Int)
//    var cellSelectedClosure: ((Bool) -> Void)? { get }
    
    var usersKeyValueArray: [(key: String, value: RoomUsers)] { get }
}
