//
//  ReceiptScreenPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation

protocol ReceiptScreenPanVMProtocol {
    
    
    var getReceipt: Receipt { get }
    var getPayerName: String { get }
    var currentNumOfUsers: Int { get }
    var getPayMethod: String { get }
    
    
    func cellViewModel(at index: Int) -> ReceiptScreenPanCellVM
    
    
    
}
