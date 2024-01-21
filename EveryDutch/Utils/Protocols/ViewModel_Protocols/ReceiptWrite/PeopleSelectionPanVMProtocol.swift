//
//  PeopleSelectionPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit


protocol PeopleSelectionPanVMProtocol {
    var peopleSelectionEnum: PeopleSeelctionEnum? { get }
    var selectedUsers: RoomUserDataDictionary { get }
    var addedUsers: RoomUserDataDictionary { get }
    var removedSelectedUsers: RoomUserDataDictionary { get }
//    var usersKeyValueArray: [(key: String, value: RoomUsers)] { get }
    
    
    var bottomBtnClosure: (() -> Void)? { get set }
    
    
    var isSingleMode: Bool { get }
    var numOfUsers: Int { get }
    
    var topLblText: String { get }
    
    
    var bottomBtnIsEnabled: Bool { get }
    var bottomBtnColor: UIColor { get }
    var bottomBtnTextColor: UIColor { get }
    
    
    var bottomBtnText: String { get }
    
    func returnUserData(index: Int) -> (key: String, value: RoomUsers)
    
    
    func multipleModeSelectedUsers(index: Int)
    
    func singleModeSelectionUser(index: Int)
    
    func getIdToRoomUser(usersID: String) -> Bool
}
