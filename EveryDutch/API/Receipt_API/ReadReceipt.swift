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
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryLimited(toLast: 8)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(.failure(.readError))
                    return
                }
                print("가져온 receipt 갯수 ----- \(allObjects.count)")
                var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                    }
                }
                
                // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 합니다.
                receiptsTupleArray.reverse()
                
                // 마지막 항목의 키를 저장
                if let lastSnapshot = allObjects.first {
                    if let date = lastSnapshot.childSnapshot(forPath: DatabaseConstants.date).value as? Int {
                        self.lastKey = "\(date)_\(lastSnapshot.key)"
                    }
                }
                
                print("lastKey ----- \(self.lastKey ?? "Error")")
                completion(.success(.initialLoad(receiptsTupleArray)))
            }
    }
    
    func loadMoreReceipts(
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    ) {
        print(#function)
        guard let lastKey = self.lastKey else {
            completion(.failure(.noMoreData))
            return
        }

        let parts = lastKey.split(separator: "_")
        guard parts.count == 2,
              let lastDate = Int(parts.first ?? "") 
        else {
            completion(.failure(.readError))
            return
        }
        
        let lastID = String(parts.last ?? "")
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryEnding(beforeValue: lastDate)
            .queryLimited(toLast: 8)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(.failure(.readError))
                    return
                }
                
                var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
                
                allObjects.forEach { snapshot in
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                    }
                }
                
                // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 합니다.
                receiptsTupleArray.reverse()
                
                // 더 이상 데이터가 없으면 lastKey를 업데이트하지 않고 종료
                if receiptsTupleArray.isEmpty {
                    completion(.failure(.noMoreData))
                } else {
                    if let lastSnapshot = allObjects.first {
                        if let date = lastSnapshot.childSnapshot(forPath: DatabaseConstants.date).value as? Int {
                            self.lastKey = "\(date)_\(lastSnapshot.key)"
                        }
                    }
                    completion(.success(receiptsTupleArray))
                }
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

