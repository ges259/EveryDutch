//
//  SettlementTableViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

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
    var getBackgroundColor: UIColor {
        switch self.receipt.type {
        case -1:
            return .red
        case 0:
            return .normal_white
        case 1:
            return .medium_Blue
        default:
            return .normal_white
        }
    }
    
    var receiptDate: String {
        return self.receipt.date
    }
    
    mutating func setReceipt(_ receipt: Receipt) {
        self.receipt = receipt
    }
    
    mutating func updateReceipt(receiptID: String, _ dict: [String: Any]) {
        self.receipt = Receipt(receiptID: receiptID, dictionary: dict)
    }
}
