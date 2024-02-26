//
//  Receipt_API.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabaseInternal

// Read
    // Receipt에서 데이터 가져오기 ----- (Receipt)

extension ReceiptAPI {
    

    // version_ID: String,
    func readReceipt(completion: @escaping Typealias.ReceiptCompletion) {
        // MARK: - Fix
        RECEIPT_REF
            .child("version_ID_1")
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryLimited(toLast: 8)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                var receipts = [Receipt]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receipts.append(receipt)
                    }
                }
                
                completion(.success(receipts))
                
            }
    }
}
                
