//
//  Receipt_Enum.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit

enum ReceiptEnum {
    case memo
    case date
    case time
    case price
    case payer
    case payment_Method
    
    var img: UIImage? {
        switch self {
        case .memo: return UIImage.memo_Img
        case .date: return UIImage.calendar_Img
        case .time: return UIImage.clock_Img
        case .price: return UIImage.won_Img
        case .payer: return UIImage.person_Img
        case .payment_Method: return UIImage.n_Mark_Img
        }
    }
    
    var text: String {
        switch self {
        case .memo: return "메모"
        case .date: return "날짜"
        case .time: return "시간"
        case .price: return "금액"
        case .payer: return "계산"
        case .payment_Method: return "정산"
        }
    }
}

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
