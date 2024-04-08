//
//  APIError.swift
//  EveryDutch
//
//  Created by 계은성 on 1/10/24.
//

import Foundation

enum ErrorEnum: Error {
    
    case changeEditDataError
    
    
    case validationError(_ databaseString: [String])
    
    case writeError
    case readError
    case loginError
    case receiptCreateError
    
    case receiptHasNilValue(_ receiptDict: [String: Any?])
    case receiptAPIFailed(_ receiptDict: [String: Any?])
    case receiptCheckFailed(_ receiptDict: [ReceiptCheck])
    
    case NotLoggedIn
    case NoPersonalID
    
    // FindFriendsVC
    case userNotFound
    
    
    
    
    // UpdateRooms + FindFriendsVC
    // 검색
    case containsWhitespace // 띄어쓰기 포함 에러
    case invalidCharacters // 특수 문자 포함 에러
        // 유저 ID가 있지만, 검색 실패
    case searchFailed
        // 텍스트필드의 데이터 형식이 잘못 됨,
    case searchIdError
        // 유저가 이미 존재
    case userAlreadyExists
    
    
    // RoomID 및 RoomUser 저장 실패
    case roomUserIDUpdateFailed
    case roomUserUpdateFailed
    case inviteFailed
    
    // RoomID / VersionID / UserID 가 잘못 됨.
    case roomDataError
    
    // 알 수 없는 에러
    case unknownError
    
    
    var alertType: AlertEnum {
        switch self {
            // RoomID 및 RoomUser 저장 실패
        case .searchFailed:
            return .searchFailed
        
        case .searchIdError:
            return .searchIdError
            
        case .userAlreadyExists:
            return .userAlreadyExists
            
            // RoomID / VersionID / UserID 가 잘못 됨.
        case .roomDataError: 
            return .roomDataError
            
        case .roomUserUpdateFailed,
                .roomUserIDUpdateFailed:
            return .inviteFailed
            
        case .inviteFailed:
            return .inviteFailed
            
            // 알 수 없는 에러
        default:
            return .unknownError
        }
    }
    
}
