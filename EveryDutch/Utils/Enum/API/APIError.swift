//
//  APIError.swift
//  EveryDutch
//
//  Created by 계은성 on 1/10/24.
//

import Foundation

enum ErrorEnum: Error {
    // 이거를 사용해줘. 나중에 바꿀 거야.
    case readError
    case loginError
    case receiptCreateError
    
    case receiptHasNilValue(_ receiptDict: [String: Any?])
    case receiptAPIFailed(_ receiptDict: [String: Any?])
}
