//
//  profileEditEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import Foundation


protocol CellTitleProvider {
    var headerTitle: String { get }
    var cellTitle: [String] { get }
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


enum ProfileEditEnum: CaseIterable, CellTitleProvider {
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


enum RoomEditEnum: CaseIterable, CellTitleProvider {
    case roomData
    case cardDecoration
    
    var headerTitle: String {
        switch self {
        case .roomData:
            return "정산방 정보"
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









//
//enum EditSectionType {
//    case profile(profileEditEnum)
//    case room(RoomEditEnum)
//
//    var headerTitle: String {
//        switch self {
//        case .profile(let type):
//            return type.headerTitle
//        case .room(let type):
//            return type.headerTitle
//        }
//    }
//
//    var cellTitle: [String] {
//        switch self {
//        case .profile(let type):
//            return type.cellTitle
//        case .room(let type):
//            return type.cellTitle
//        }
//    }
//}
