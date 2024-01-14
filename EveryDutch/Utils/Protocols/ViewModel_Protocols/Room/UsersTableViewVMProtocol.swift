//
//  UsersTableViewVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import Foundation

protocol UsersTableViewVMProtocol {
    var customTableEnum: CustomTableEnum { get }
    
    var numbersOfUsers: Int { get }
    
    
    func cellViewModel(at index: Int) -> UsersTableViewCellVM
    func makeCellVM(moneyData: [MoneyData])
}
