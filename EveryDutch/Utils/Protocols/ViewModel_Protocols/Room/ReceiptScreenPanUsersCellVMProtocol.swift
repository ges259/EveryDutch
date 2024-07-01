//
//  ReceiptScreenPanCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol ReceiptScreenPanUsersCellVMProtocol {
    
    var getUserName: String { get }
    var profileImg: UIImage? { get }
    
    var getPay: Int { get }
    var getUserID: String { get }
    
    var getPaymentDetail: PaymentDetail { get }
    mutating func toggleDone() 
    
    
    var getDone: Bool { get }
    
    var doneImg: UIImage? { get }
}
