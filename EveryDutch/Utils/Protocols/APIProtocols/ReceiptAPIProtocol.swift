//
//  ReceiptAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation
protocol ReceiptAPIProtocol {
    static var shared: ReceiptAPIProtocol { get }
    
    
    
    func createReceipt(versionID: String,
                       dictionary: [String: Any?],
                       users: [String],
                       completion: @escaping () -> Void)
    
    func updateCumulativeMoney(versionID: String,
                           usersMoneyDict: [String: Int],
                           completion: @escaping (Result<(), ErrorEnum>) -> Void)
    
    func readReceipt(completion: @escaping Typealias.ReceiptCompletion)
    
    
    
    func updatePayback(versionID: String,
                       payerID: String,
                       usersMoneyDict: [String: Int],
                       completion: @escaping (Result<(), ErrorEnum>) -> Void)
    
    
    
}
