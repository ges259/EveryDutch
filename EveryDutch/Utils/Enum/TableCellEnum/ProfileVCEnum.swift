//
//  ProfileVCEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import Foundation
import UIKit

enum ProfileVCEnum: CaseIterable {
    case userInfo
    case others
    
    
    var headerTitle: String {
        switch self {
        case .userInfo: return "회원 정보"
        case .others: return "기타"
        }
    }
    
    var cellTitle: [String] {
        switch self {
        case .userInfo: 
            return ["계정 ID",
                    "닉네임"]
            
        case .others:
            return ["로그아웃",
                    "회원탈퇴"]
        }
    }
}







protocol CellTitleProvider {
}

extension CellTitleProvider {
    // 공통으로 제공되는 cardDecorationTitle
    var cardDecorationTitle: [String] {
        return ["블러효과 적용", 
                "글자 색상", 
                "포인트 색상",
                "배경 색상"]
    }
    var cardHeaderTitle: String {
        return "카드 설정"
    }
}



enum ProfileEdit: CaseIterable, CellTitleProvider {
    case userData
    case cardDecoration
    
    var headerTitle: String {
        switch self {
        case .userData:
            return "회원 정보"
        case .cardDecoration: 
            return self.cardHeaderTitle
        }
    }
    
    var cellTitle: [String] {
        switch self {
        case .userData:
            return ["닉네임",
                    "개인 ID"]
        case .cardDecoration: 
            return cardDecorationTitle
        }
    }
}

enum RoomEdit: CaseIterable, CellTitleProvider {
    case roomData
    case cardDecoration
    
    var headerTitle: String {
        switch self {
        case .roomData:
            return "회원 정보"
        case .cardDecoration:
            return self.cardHeaderTitle
        }
    }
    
    var cellTitle: [String] {
        switch self {
        case .roomData: 
            return ["정산방 이름",
                    "모임 이름",
                    "총무 이름"]
        case .cardDecoration:
            return cardDecorationTitle
        }
    }
}
