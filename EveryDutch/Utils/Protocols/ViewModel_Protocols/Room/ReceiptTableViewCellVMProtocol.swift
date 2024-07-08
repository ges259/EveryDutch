//
//  SettlementTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

protocol ReceiptTableViewCellVMProtocol {
    
    var getBackgroundColor: UIColor { get }
    
    var getReceiptID: String { get }
    
    var getReceipt: Receipt { get }
    
    var receiptDate: String { get }
    
    mutating func setReceipt(_ receipt: Receipt)
    
    mutating func updateReceipt(receiptID: String, _ dict: [String: Any]) 
}
