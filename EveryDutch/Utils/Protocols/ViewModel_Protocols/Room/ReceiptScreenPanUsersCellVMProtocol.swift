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
    
    
    mutating func changeDoneValue(_ bool: Bool)
    
    
    var doneImg: UIImage? { get }
    var doneStatusChanged: ((UIImage?) -> Void)? { get set }
}
