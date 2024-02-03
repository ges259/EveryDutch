//
//  UsersTableViewVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

protocol UsersTableViewVMProtocol {
    var customTableEnum: UsersTableEnum { get }
    
    var numbersOfUsers: Int { get }
    
    var firstBtnTapped: Bool { get set }
    var getBtnColor: [UIColor] { get }
    
    
    func cellViewModel(at index: Int) -> UsersTableViewCellVM
    func makeCellVM()
}
