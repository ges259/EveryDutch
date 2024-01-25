//
//  ReceiptCheckEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 1/25/24.
//

import Foundation

enum ReceiptCheck: String, CustomStringConvertible {
    case memo
    case price
    case payer
    case cumulativeMoney
    case selectedUsers
    case usersPriceZero
    
    var description: String {
        switch self {
        case .memo: return "✓  메모을 작성해 주세요"
        case .price:
            return "✓  가격을 설정해 주세요"
        case .payer: return "✓  계산한 사람을 설정해 주세요."
        case .selectedUsers: return "✓  함께 계산한 사람을 모두 선택해 주세요."
        case .cumulativeMoney: return "✓  금액이 맞지 않습니다. 정확히 입력해 주세요."
        case .usersPriceZero: return "✓  0원으로 설정되어있는 사람이 있습니다."
        }
    }
}
