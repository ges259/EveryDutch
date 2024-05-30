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
//            .queryLimited(toLast: 3)
extension ReceiptAPI {

    func readReceipt(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void)
    {
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryLimited(toLast: 7)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                    }
                }
                // 마지막 항목의 키를 저장
                self.lastKey = allObjects.last?.key
                
                completion(.success(.initialLoad(receiptsTupleArray)))
            }
    }
    
    
    
    
    func loadMoreReceipts(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void)
    {
        guard let lastKey = self.lastKey else {
            completion(.failure(.noMoreData))
            return
        }
        
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryEnding(atValue: lastKey)
            .queryLimited(toLast: 6) // 마지막 항목 포함해서 가져오기 때문에 6개로 설정
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                    }
                }
                
                // 마지막 항목 제거 (이미 로드된 항목)
                if !receiptsTupleArray.isEmpty {
                    receiptsTupleArray.removeFirst()
                }
                
                // 새로운 마지막 항목의 키를 저장
                self.lastKey = allObjects.last?.key
                
                completion(.success(.added(receiptsTupleArray)))
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
                let receiptTuple = (receiptID: snapshot.key, receipt: receipt)
                completion(.success(.added([receiptTuple])))
            } else {
                completion(.failure(.readError))
            }
        }
        
        path.observe(.childChanged) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                // [receiptID : [String: Any]]
                // [String: Any] -> Receipt 객체를 만들 때 사용
                completion(.success(.updated([snapshot.key: dict])))
            } else {
                completion(.failure(.readError))
            }
        }
        
        path.observe(.childRemoved) { snapshot in
            let receiptID = snapshot.key
            completion(.success(.removed(receiptID)))
        }
    }
}

