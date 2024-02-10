//
//  ReceiptAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation
protocol ReceiptAPIProtocol {
    static var shared: ReceiptAPI { get }
    typealias ReceiptCompletion = (Result<[Receipt], ErrorEnum>) -> Void
    
    
    
    func createReceipt(roomData: [String],
                       context: String?,
                       date: Int,
                       time: String,
                       price: Int,
                       payer: String,
                       paymentDetails: [String: Int])
    
    func readReceipt(completion: @escaping ReceiptCompletion)
    
}
