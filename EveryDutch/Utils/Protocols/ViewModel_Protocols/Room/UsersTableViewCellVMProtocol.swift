//
//  UsersTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol UsersTableViewCellVMProtocol {
    
    var cumulativeAmount: Int { get }
    var customTableEnum: UsersTableEnum { get }
    
    var profileImg: UIImage? { get }
    
    var rightBtnImg: UIImage? { get }
    var paybackPrice: Int { get }
    
    
    
    var isButtonExist: Bool { get }
    var imgLeftAnchor: CGFloat { get }
    
    
    var getUserName: String { get }
    
    var userID: String { get }
    
     
    
    mutating func updateUserData(_ user: [String: Any]) -> User?
    
    mutating func setCumulativeAmount(_ amount: Int)
    mutating func setpayback(_ amount: Int)
}
