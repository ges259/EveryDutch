//
//  ReceiptAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation
protocol ReceiptAPIProtocol {
    static var shared: ReceiptAPIProtocol { get }
    
    
    
    // MARK: - 영수증 만들기
    func createReceipt(
        versionID: String,
        dictionary: [String: Any?],
        retryCount: Int,
        completion: @escaping Typealias.CreateReceiptCompletion)
    
    func saveReceiptForUsers(receiptID: String,
                             users: [String],
                             retryCount: Int,
                             completion: @escaping Typealias.baseCompletion)
    
    
    func updateCumulativeMoney(versionID: String,
                               usersMoneyDict: [String: Int],
                               retryCount: Int,
                               completion: @escaping Typealias.baseCompletion)
    
    
    
    
    
    func updatePayback(versionID: String,
                       payerID: String,
                       usersMoneyDict: [String: Int],
                       retryCount: Int,
                       completion: @escaping Typealias.baseCompletion)
    
    
    
    
    
    
    
    
//    func readReceipt(completion: @escaping Typealias.ReceiptCompletion)
    func readReceipt(versionID: String, completion: @escaping Typealias.ReceiptCompletion)
}
