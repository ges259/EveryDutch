//
//  ReceiptAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation
protocol ReceiptAPIProtocol {
    static var shared: ReceiptAPIProtocol { get }
    typealias ReceiptCompletion = (Result<[Receipt], ErrorEnum>) -> Void
    
    
    func createReceipt(versionID: String,
                       dictionary: [String: Any?],
                       completion: @escaping () -> Void)
    
    
    
    func readReceipt(completion: @escaping ReceiptCompletion)
    
}
