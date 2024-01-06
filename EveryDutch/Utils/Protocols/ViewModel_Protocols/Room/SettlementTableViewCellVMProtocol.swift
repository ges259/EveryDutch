//
//  SettlementTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

protocol SettlementTableViewCellVMProtocol {
    var content: String { get }
    var price: Double { get }
    var date: Date { get }
    var payer: String { get }
}
