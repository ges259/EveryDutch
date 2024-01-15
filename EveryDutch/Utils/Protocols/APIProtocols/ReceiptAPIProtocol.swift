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
    
    
    
    func createReceipt()
    
    func readReceipt(completion: @escaping ReceiptCompletion)
    
}
