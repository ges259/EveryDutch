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
    case backgroundSelect
    
    case userAlreadyExists
    case searchFailed
    case searchIdError
    case roomDataError
    case inviteFailed
    case unknownError
    
    
    case blurSetError
    case colorSetError
    case imageSetError
    case decorationSetError
    
    
    case inviteSuccess
    
    case photoAccess
    
    case noImage
    
    var title: String {
        switch self {
        case .backgroundSelect:
            return ""
        case .noImage:
            return "가져올 수 있는 사진이 없습니다."
        case .photoAccess:
            return "사진 라이브러리 접근 권한 필요"
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
            return "알 수 없는 오류"
        case .inviteSuccess:
            return "초대 성공"
        case .colorSetError:
            return "색상 선택 오류"
        case .imageSetError:
            return "이미지 선택 오류"
        case .blurSetError:
            return "블러 선택 오류"
        case .decorationSetError:
            return "카드 효과 변경 오류"
        }
    }
    
    var message: String {
        switch self {
        case .photoAccess:
            return "앱에서 사진을 선택하기 위해서는 사진 라이브러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요."
        case .colorSetError,
                .imageSetError,
                .blurSetError,
                .decorationSetError:
            return "다시 시도해 주세요."
        default:
            return ""
        }
    }
    
    var buttons: [String] {
        switch self {
        case .backgroundSelect:
            return ["이미지 선택",
                    "색상 선택"]
        case .photoAccess:
            return ["설정으로 이동"]
            
        case .loginFail:
            return ["확인"]
        default: 
            return ["확인"]
        }
    }
    
    var cancelBtn: Bool {
        switch self {
        case .photoAccess, .backgroundSelect:
            return true
            
        default:
            return false
        }
    }
}
