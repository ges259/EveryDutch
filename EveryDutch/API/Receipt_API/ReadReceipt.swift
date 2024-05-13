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

    func readReceipt(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void)
    {
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
//            .queryLimited(toLast: 3)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                var receiptsTupleArray = [(roomID: String, receipt: Receipt)]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receiptsTupleArray.append((roomID: snapshot.key, receipt: receipt))
                    }
                }
                
//                let returnTupleArray = Array(receiptsTupleArray.reversed())
                completion(.success(.initialLoad(receiptsTupleArray)))
            }
    }
    
    func observeReceipt(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void)
    {
        let path = RECEIPT_REF.child(versionID)
        
        path.observe(.childAdded) { snapshot in
               if let dict = snapshot.value as? [String: Any] {
                   let receipt = Receipt(dictionary: dict)
                   let receiptTuple = (roomID: snapshot.key, receipt: receipt)
                   completion(.success(.added([receiptTuple])))
               } else {
                   completion(.failure(.readError))
               }
        }
        
//        path.observe(.childChanged) { snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                // [receiptID : [String: Any]]
//                // [String: Any] -> Receipt 객체를 만들 때 사용
//                completion(.success(.updated([snapshot.key: dict])))
//            } else {
//                completion(.failure(.readError))
//            }
//        }
//        
//        path.observe(.childRemoved) { snapshot in
//            let receiptID = snapshot.key
//            completion(.success(.removed(receiptID)))
//        }
    }
}

