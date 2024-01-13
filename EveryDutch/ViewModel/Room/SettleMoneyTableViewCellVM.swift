//
//  SettlementTableViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

struct SettleMoneyTableViewCellVM: SettlementTableViewCellVMProtocol {
//    let content: String
//    let price: Double
//    let date: Date
//    let payer: String

//    init(settlement: Settlement) {
//        self.content = settlement.content
//        self.price = settlement.price
//        self.date = settlement.date
//        self.payer = settlement.payer
//    }
    
    var type: Int
    var context: String
    var date: String
    var time: String
    var price: Int
    var payer: String
    var paymentMethod: Int
//    var paymentDetails: [PaymentDetail]
    
    init(receiptData: Receipt) {
        self.type = receiptData.type
        self.context = receiptData.context
        self.date = receiptData.date
        self.time = receiptData.time
        self.price = receiptData.price
        self.payer = receiptData.payer
        self.paymentMethod = receiptData.paymentMethod
    }
}
