//
//  ReceiptAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation
protocol ReceiptAPIProtocol {
    
    
    
    
    // MARK: - 영수증 만들기
    func createReceipt(
        versionID: String,
        dictionary: [String: Any?],
        retryCount: Int,
        completion: @escaping Typealias.CreateReceiptCompletion)
    
    func saveReceiptForUsers(receiptID: String,
                             users: [String],
                             retryCount: Int,
                             completion: @escaping Typealias.VoidCompletion)
    
    
    func updateCumulativeMoney(versionID: String,
                               usersMoneyDict: [String: Int],
                               retryCount: Int,
                               completion: @escaping Typealias.VoidCompletion)
    
    
    
    
    
    func updatePayback(versionID: String,
                       payerID: String,
                       usersMoneyDict: [String: Int],
                       retryCount: Int,
                       completion: @escaping Typealias.VoidCompletion)
    
    
    
    
    
    
    
    
//    func readReceipt(completion: @escaping Typealias.ReceiptCompletion)
    func readReceipt(versionID: String, completion: @escaping Typealias.ReceiptArrayCompletion)
}
