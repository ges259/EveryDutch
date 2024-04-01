//
//  AlertEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 3/18/24.
//

import Foundation

enum AlertEnum {
    case loginFail
    case logout
    case timeFormat
    
    
    case userAlreadyExists
    case searchFailed
    case searchIdError
    case roomDataError
    case inviteFailed
    case unknownError
    
    
    case inviteSuccess
    
    
    var title: String {
        switch self {
        case .loginFail:
            return "로그인에 실패하였습니다. 다시 시도해 주세요."
        case .logout:
            return ""
        case .timeFormat:
            return "시간 형식을 선택해주세요"
        case .userAlreadyExists:
            return "userAlreadyExists"
        case .searchFailed:
            return "searchFailed"
        case .searchIdError:
            return "searchIdError"
        case .roomDataError:
            return "roomDataError"
        case .inviteFailed:
            return "inviteFailed"
        case .unknownError:
            return "unknownError"
        case .inviteSuccess:
            return "초대 성공"
        }
    }
    
    var message: String {
        switch self {
        default:
            return ""
        }
    }
    
    var buttons: [String] {
        switch self {
        case .loginFail: return ["확인"]
        default: return ["확인"]
        }
    }
}
