//
//  SettlementTableViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

struct ReceiptTableViewCellVM: ReceiptTableViewCellVMProtocol {
    private let receiptID: String
    private var receipt: Receipt
    
    init(receiptID: String, receiptData: Receipt) {
        self.receiptID = receiptID
        self.receipt = receiptData
    }
    
    
    var getReceiptID: String {
        return self.receiptID
    }
    
    var getReceipt: Receipt {
        return self.receipt
    }
    
    
    var receiptDate: String {
        return self.receipt.date
    }
    
    mutating func setReceipt(_ receipt: Receipt) {
        self.receipt = receipt
    }
    
    mutating func updateReceipt(_ dict: [String: Any]) {
        self.receipt = Receipt(dictionary: dict)
    }
}
