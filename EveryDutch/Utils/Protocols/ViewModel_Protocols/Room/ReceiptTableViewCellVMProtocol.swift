//
//  SettlementTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

protocol ReceiptTableViewCellVMProtocol {
    
    
    var getReceiptID: String { get }
    
    var getReceipt: Receipt { get }
    mutating func setReceipt(_ receipt: Receipt)
    
    mutating func updateReceipt(_ dict: [String: Any])
}
