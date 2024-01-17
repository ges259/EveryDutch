//
//  ReceiptWirteVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

protocol ReceiptWriteVMProtocol {
    
    
    var numOfUsers: Int { get }
    
    
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM
    
    var dutchBtnColor: UIColor { get }
}
