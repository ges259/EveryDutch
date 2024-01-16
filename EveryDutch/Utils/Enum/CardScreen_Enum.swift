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
    case makeRoom
    case infoFix_User
    
    case readMode
    case readMode_profile
    case info_Btn
    
    var configureTitle: [String] {
        switch self {
        case .makeRoom: return ["정산방 정보",
                                "정산방 이름",
                                "모임 이름"]
        case .infoFix_User: return ["회원 정보",
                                    "개인_ID",
                                    "닉네임"]
        case .readMode, .readMode_profile: return ["회원 정보",
                                                   "개인_ID",
                                                   "닉네임"]
        case .info_Btn: return ["기타",
                                "로그아웃",
                                "회원 탈퇴"]
        }
    }
    
    var thirdViewTitle: String {
        switch self {
        case .makeRoom: return "배경 이미지 설정"
        case .infoFix_User: return "프로필 이미지 설정"
        case .readMode, .readMode_profile: return "이메일"
        case .info_Btn: return ""
        }
    }
    
    var placeholderTitle: [String] {
        switch self {
            
        case .makeRoom: return ["정산방의 이름을 설정해 주세요.",
                                "모임의 이름을 설정해 주세요."]
        case .infoFix_User: return ["",
                                    "닉네임을 설정해 주세요."]
        case .readMode, .readMode_profile, .info_Btn: return []
        }
    }
    
}




