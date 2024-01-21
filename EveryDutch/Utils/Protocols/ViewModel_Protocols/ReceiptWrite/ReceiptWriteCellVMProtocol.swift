//
//  ReceiptWriteCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation

protocol ReceiptWriteCellVMProtocol {
    var userID: String { get }
    
    
    func configureLblFormat(price: String) -> String?
    
    
    func removeFormat(text: String?) -> String
    func textIsZero(text: String?) -> String?
    func configureTfFormat(text: String?) -> String?
}
