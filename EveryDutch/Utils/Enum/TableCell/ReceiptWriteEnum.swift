//
//  ReceiptWriteEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/8/24.
//

import Foundation

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
