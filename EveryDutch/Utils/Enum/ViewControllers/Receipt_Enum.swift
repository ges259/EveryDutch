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
    
    
    
    // 각 케이스에 대한 이미지와 텍스트를 named tuple로 반환
    var cellInfoTuple: (img: UIImage?, text: String) {
        switch self {
        case .memo:             return (UIImage.memo_Img,       "메모")
        case .date:             return (UIImage.calendar_Img,   "날짜")
        case .time:             return (UIImage.clock_Img,      "시간")
        case .price:            return (UIImage.won_Img,        "금액")
        case .payer:            return (UIImage.person_Img,     "계산")
        case .payment_Method:   return (UIImage.n_Mark_Img,     "정산")
        }
    }
    
    
    func detail(from receipt: Receipt) -> String {
         switch self {
         case .memo:
             return receipt.context
         case .date:
             return receipt.date
         case .time:
             return receipt.time
         case .price:
             return NumberFormatter.localizedString(from: NSNumber(value: receipt.price), number: .currency)
         case .payer:
             return receipt.payer
         case .payment_Method:
             return "\(receipt.paymentMethod)"
         }
     }
}


