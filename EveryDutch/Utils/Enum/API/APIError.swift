//
//  APIError.swift
//  EveryDutch
//
//  Created by 계은성 on 1/10/24.
//

import Foundation

enum ErrorEnum: Error {
    
    case readError
    case loginError
    case receiptCreateError
    
    case receiptHasNilValue(_ receiptDict: [String: Any?])
    case receiptAPIFailed(_ receiptDict: [String: Any?])
    case receiptCheckFailed(_ receiptDict: [ReceiptCheck])
    
    
    
    // FindFriendsVC
    case userNotFound
    
    
    
    
    // UpdateRooms
    case userAlreadyExists
    case updateFailed
    case roomUserIDUpdateFailed
    case roomUserUpdateFailed
}
