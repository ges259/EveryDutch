//
//  CreateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

// Create
    // Receipt에 데이터 저장 ----- (Receipt)
    // 개인적으로 데이터 저장 ----- (User_Receipt)

// Read
    // Receipt에서 데이터 가져오기 ----- (Receipt)

// Update
    // type 변경 ----- (Receipt)
    // payment_details[done: Bool] 변경 ----- (Receipt)

// Delete
    // 영수증 삭제
        // User_Receipt에서 삭제
        // Receipt에서 삭제
struct ReceiptAPI: ReceiptAPIProtocol {
    static let shared: ReceiptAPIProtocol = ReceiptAPI()
    private init() {}
    
    
    typealias ReceiptCompletion = (Result<[Receipt], ErrorEnum>) -> Void
}


extension ReceiptAPI {
    func createReceipt(versionID: String,
                       dictionary: [String: Any?],
                       completion: @escaping () -> Void) {
        
        let dict = dictionary.compactMapValues{ $0 }
        
        RECEIPT_REF
            .child(versionID)
            .childByAutoId()
            .setValue(dict) { error, ref in
                
            if let error = error {
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                print("Data saved successfully!")
                
                completion()
            }
        }
    }
    
    private func updateCumulativeMoney(versionID: String) {
        Cumulative_AMOUNT_REF
            .child(versionID)
    }
    private func updatePayback() {
//        PAYBACK_REF
    }
}
