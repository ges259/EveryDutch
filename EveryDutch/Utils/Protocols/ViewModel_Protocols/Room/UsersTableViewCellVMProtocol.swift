//
//  UsersTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol UsersTableViewCellVMProtocol {
    var profileImageURL: String { get }
    var userName: String { get }
    var cumulativeAmount: Int { get }
    var customTableEnum: UsersTableEnum { get }
    
    var profileImg: UIImage? { get }
    
    var rightBtnImg: UIImage? { get }
    var paybackPrice: Int { get }
    
    
    
    var isButtonExist: Bool { get }
    var imgLeftAnchor: CGFloat { get }
    
    
    
    
    var userID: String { get }
    
     
    
    
    
    mutating func setCumulativeAmount(_ amount: Int)
    mutating func setpayback(_ amount: Int)
}
