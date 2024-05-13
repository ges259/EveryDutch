//
//  SettlementTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

protocol ReceiptTableViewCellVMProtocol {
    var type: Int { get }
    var context: String { get }
    var time: String { get }
    var price: Int { get }
    var payer: String { get }
    
    
    var getReceiptID: String { get }
    
    var getReceipt: Receipt { get }
    mutating func updateReceipt(_ dict: [String: Any])
}
