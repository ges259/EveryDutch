//
//  Notification+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 6/8/24.
//

import Foundation

extension Notification.Name {
    static let numberOfUsersChanges = Notification.Name("numberOfUsersChanges")
    static let receiptDataChanged = Notification.Name("receiptDataChanged")
//    static let receiptSearchModeChanged = Notification.Name("receiptSearchModeChanged")
    static let roomDataChanged = Notification.Name("roomDataChanged")
    static let userDataChanged = Notification.Name("userDataChanged")
    static let searchDataChanged = Notification.Name("serachDataChanged")
    
    
    
    static let presentViewChanged = Notification.Name("presentViewChanged")
}
