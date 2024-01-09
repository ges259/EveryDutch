//
//  SettlementTableViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

struct SettlementTableViewCellVM: SettlementTableViewCellVMProtocol {
    let content: String
    let price: Double
    let date: Date
    let payer: String

//    init(settlement: Settlement) {
//        self.content = settlement.content
//        self.price = settlement.price
//        self.date = settlement.date
//        self.payer = settlement.payer
//    }
    
    init(content: String,
         payer: String) {
        self.content = content
        self.price = 2
        self.date = Date()
        self.payer = payer
    }
}
