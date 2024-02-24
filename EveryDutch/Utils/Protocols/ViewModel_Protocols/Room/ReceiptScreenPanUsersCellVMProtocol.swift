//
//  ReceiptScreenPanCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol ReceiptScreenPanUsersCellVMProtocol {
    var pay: Int { get }
    var profileImg: UIImage? { get }
    var doneImg: UIImage? { get }
    var userName: String { get }
    var done: Bool { get set }
    
    
    var doneStatusChanged: ((UIImage?) -> Void)? { get set }
}
