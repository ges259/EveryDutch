//
//  PeopleSelectionPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit


protocol PeopleSelectionPanVMProtocol {
    var peopleSelectionEnum: PeopleSeelctionEnum { get }
    var selectedUsers: RoomUserDataDict { get }
    var addedUsers: RoomUserDataDict { get }
    var removedSelectedUsers: RoomUserDataDict { get }
//    var usersKeyValueArray: [(key: String, value: RoomUsers)] { get }
    
    func getSelectedUsersIndexPath() -> IndexPath?
    
    
    var isFirst: Bool { get set }
    
    
    
    
    
    
    
    
    
    
    
    
    var bottomBtnClosure: (() -> Void)? { get set }
    
    
    var isSingleSelectionMode: Bool { get }
    var numOfUsers: Int { get }
    
    var topLblText: String { get }
    
    
    var bottomBtnIsEnabled: Bool { get }
    var bottomBtnColor: UIColor { get }
    var bottomBtnTextColor: UIColor { get }
    
    
    var bottomBtnText: String { get }
    
    func returnUserData(index: Int) -> (key: String, value: User)
    
    
    func multipleModeSelectedUsers(index: Int)
    
    func singleModeSelectionUser(index: Int)
    
    func getIdToRoomUser(userID: String) -> Bool
}
