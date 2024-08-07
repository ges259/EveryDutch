//
//  DebounceType.swift
//  EveryDutch
//
//  Created by 계은성 on 6/8/24.
//

import Foundation

enum DebounceType {
    case userData
    case roomData
    case receiptData
    case searchData
    
    var queue: DispatchQueue {
        switch self {
        case .userData:
            return DispatchQueue(label: "user-data-queue", qos: .userInitiated)
        case .roomData:
            return DispatchQueue(label: "room-data-queue", qos: .userInitiated)
        case .receiptData:
            return DispatchQueue(label: "receipt-data-queue", qos: .userInitiated)
        case .searchData:
            return DispatchQueue(label: "search-data-queue", qos: .userInitiated)
        }
    }
    
    var notificationName: Notification.Name {
        switch self {
        case .userData:
            return .userDataChanged
        case .roomData:
            return .roomDataChanged
        case .receiptData:
            return .receiptDataChanged
        case .searchData:
            return .searchDataChanged
        }
    }
    
    var interval: CGFloat {
        switch self {
        case .userData:
            return 0.2
        case .roomData:
            return 1.5
        case .receiptData, .searchData:
            return 0.4
        }
    }
}
