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
    var price: String { get }
    var customTableEnum: CustomTableEnum { get }
    
    var profileImg: UIImage? { get }
}
