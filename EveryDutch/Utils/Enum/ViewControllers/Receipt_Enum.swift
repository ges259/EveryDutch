//
//  Receipt_Enum.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit

enum ReceiptEnum: CaseIterable {
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
    
    var databaseString: String {
        switch self {
        case .memo:             return DatabaseConstants.context
        case .date:             return DatabaseConstants.date
        case .time:             return DatabaseConstants.time
        case .price:            return DatabaseConstants.price
        case .payer:            return DatabaseConstants.pay
        case .payment_Method:   return DatabaseConstants.payment_method
        }
    }
}
