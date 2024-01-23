//
//  PeopleSelectionDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 1/18/24.
//

import Foundation


protocol PeopleSelectionDelegate: AnyObject {
    func multipleModeSelectedUsers(
        peopleSeelctionEnum: PeopleSeelctionEnum?,
        addedusers: RoomUserDataDictionary,
        removedUsers: RoomUserDataDictionary)

}
