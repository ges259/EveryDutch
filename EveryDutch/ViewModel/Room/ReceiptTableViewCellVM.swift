//
//  SettlementTableViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

struct ReceiptTableViewCellVM: ReceiptTableViewCellVMProtocol {
    
    var type: Int
    var context: String
    var time: String
    var price: Int
    var payer: String
    
    private let receiptID: String
    private var receipt: Receipt
    
    init(receiptID: String, receiptData: Receipt) {
        self.receiptID = receiptID
        self.receipt = receiptData
        
        self.type = receiptData.type
        self.context = receiptData.context
        self.time = receiptData.time
        self.price = receiptData.price
        self.payer = receiptData.payer
    }
    
    
    var getReceiptID: String {
        return self.receiptID
    }
    
    mutating func updateReceipt(_ dict: [String: Any]) {
        self.receipt = Receipt(dictionary: dict)
    }
}
