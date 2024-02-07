//
//  RoomEditEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import Foundation

enum RoomEditEnum: CaseIterable, CellTitleProvider {
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





enum ReceiptWriteEnum: CaseIterable {
    case receiptData
    case userData
    
    var headerTitle: String {
        switch self {
        case .receiptData:
            return "영수증 정보"
        case .userData:
            return "금액 입력"
        }
    }
}
