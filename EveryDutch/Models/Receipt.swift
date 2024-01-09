//
//  Receipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct Receipt {
    var type: Int
    var context: String
    var date: String
    var time: String
    var price: String
    var payer: String
    var paymentMethod: Int
    var paymentDetails: [PaymentDetail]

    // 지불 세부 정보를 위한 내부 구조체
    struct PaymentDetail: Codable {
        var userID: String
        var pay: Int
        var done: Bool
    }
}
