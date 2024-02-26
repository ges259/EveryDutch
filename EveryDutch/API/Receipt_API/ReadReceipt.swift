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
    func readReceipt(
        versionID: String,
        completion: @escaping Typealias.ReceiptCompletion)
    {
        
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryLimited(toLast: 3)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                var receipts = [Receipt]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receipts.append(receipt)
                    }
                }
                
                completion(.success(receipts.reversed()))
            }
    }
    
    
    
    
    func observingReceipt_Added(
        versionID: String,
        completion: @escaping Typealias.ValidationCompletion)
    {
        
        RECEIPT_REF
            .child(versionID)
            .observe(.childAdded) { snapshot in
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                if let dict = snapshot.value as? [String: Any] {
                    let receipt = Receipt(dictionary: dict)
                    completion(.success(receipt))
                }
            }
    }
    func observingReceipt_changed(
        versionID: String,
        completion: @escaping Typealias.ValidationCompletion)
    {
        RECEIPT_REF
            .child(versionID)
            .observe(.childChanged) { snapshot in
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                
                
            }
    }
    func observingReceipt_removed(
        versionID: String,
        completion: @escaping Typealias.ValidationCompletion)
    {
        RECEIPT_REF
            .child(versionID)
            .observe(.childRemoved) { snapshot in
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                
                
            }
    }
    
    
}
                
