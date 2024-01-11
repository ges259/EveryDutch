//
//  ReceiptScreenPanCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import Foundation

struct ReceiptScreenPanCellVM {
    var done: Bool
    var pay: Int
    var userID: String
    
    init(paymentDetail: Receipt.PaymentDetail) {
        self.done = paymentDetail.done
        self.pay = paymentDetail.pay
        self.userID = paymentDetail.userID
    }
}
