//
//  DataChangeType.swift
//  EveryDutch
//
//  Created by 계은성 on 6/8/24.
//

import Foundation

enum DataChangeEvent<T> {
    case added(T)
    case removed(String)
    case updated([String: [String: Any]])
    
    case initialLoad(T)
}

enum DataChangeType {
    case updated
    case added
    case removed
    case initialLoad
    case error
    
    case moveRows
    case sectionRemoved
    
    case sectionReload
    case sectionInsert
    
    var notificationName: String {
        switch self {
        case .initialLoad:      return "initialLoad"
        case .added:            return "added"
        case .removed:          return "removed"
        case .updated:          return "updated"
        
        case .sectionReload:    return "sectionReload"
        case .sectionInsert:    return "sectionInsert"
        case .sectionRemoved:   return "sectionRemoved"
            
        case .moveRows:         return "moveRows"
        case .error:            return "error"
        }
    }
}
