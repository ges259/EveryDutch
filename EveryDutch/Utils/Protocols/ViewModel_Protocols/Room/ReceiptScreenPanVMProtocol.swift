//
//  ReceiptScreenPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation

protocol ReceiptScreenPanVMProtocol {
    
    
    var receipt: Receipt { get }
    
    var currentNumOfUsers: Int { get }
    
    func cellViewModel(at index: Int) -> ReceiptScreenPanCellVM
    
    
    
}
