//
//  CardScreen_Enum.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/05.
//

import Foundation

enum CardScreen_Enum {
    case makeRoom
    case editProfile
    case profile
}

enum CardMode {
    case roomMake
    case roomFix
    
    case profile
    case profile_Fix
    case setting_Auth
    
    
    var title: String {
        switch self {
        case .roomMake, .roomFix:
            return "정산방 정보"
        case .profile, .profile_Fix:
            return "개인 정보"
        case .setting_Auth:
            return "기타"
        }
    }
    var description: [String] {
        switch self {
        case .roomMake, .roomFix:
            return ["정산방 이름",
                    "모임 이름"]
        case .profile, .profile_Fix:
            return ["개인 ID",
                    "닉네임"]
        case .setting_Auth:
            return ["로그아웃",
                    "회원탈퇴"]
        }
    }
    
    var btnTitle: String {
        switch self {
        case .roomFix, .roomMake:
            return "배경 이미지 설정"
            
        case .profile_Fix:
            return "프로필 이미지 설정"
            
        case .profile, .setting_Auth:
            return ""
        }
    }
    var firstTfPlaceholder: String {
        switch self {
        case .roomMake, .roomFix:
            return "정산방의 이름을 설정해 주세요."
            
        case .profile, .setting_Auth, .profile_Fix:
            return ""
        }
    }
    
    var secondTfPlaceholder: String {
        switch self {
        case .roomMake, .roomFix:
            return "모임의 이름을 설정해 주세요."
            
        case .profile_Fix:
            return "닉네임을 설정해 주세요."
            
        case .profile, .setting_Auth:
            return ""
        }
    }
}




