//
//  PaymentDetail.swift
//  EveryDutch
//
//  Created by 계은성 on 3/10/24.
//

import Foundation

// 지불 세부 정보를 위한 내부 구조체
struct PaymentDetail: Codable {
    var userID: String
    var pay: Int
    var done: Bool
}
