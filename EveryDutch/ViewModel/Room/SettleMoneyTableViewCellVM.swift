//
//  SettlementTableViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

struct SettleMoneyTableViewCellVM: SettlementTableViewCellVMProtocol {
    
    var type: Int
    var context: String
    var time: String
    var price: Int
    var payer: String
    
    init(receiptData: Receipt) {
        self.type = receiptData.type
        self.context = receiptData.context
        self.time = receiptData.time
        self.price = receiptData.price
        self.payer = receiptData.payer
    }
}
