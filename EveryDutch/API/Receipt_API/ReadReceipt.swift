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
    // MARK: - 초기 데이터 fetch
    func readRoomReceipts(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        let path = RECEIPT_REF
            .child(versionID)
            .queryLimited(toLast: 7)
        
        
        path.observeSingleEvent(of: .value) { snapshot in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(.readError))
                return
            }
            var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
            
            allObjects.forEach { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let receipt = Receipt(receiptID: snapshot.key, 
                                          dictionary: dict)
                    receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                }
            }
            
            // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 함
            receiptsTupleArray.reverse()
            
            // 마지막 항목의 키를 저장
            if let lastSnapshot = allObjects.first {
                self.roomLastKey = lastSnapshot.key
            }
            completion(.success(.added(receiptsTupleArray)))
            
            if !self.observing {
                self.observeRoomReceipts(versionID: versionID, completion: completion)
                self.observing = true
            }
        }
    }
    
    // MARK: - 추가 데이터 fetch
    func loadMoreRoomReceipts(
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    ) {
        guard let lastKey = self.roomLastKey else {
            completion(.failure(.noMoreData))
            return
        }
        
        print(#function)
        let path = RECEIPT_REF
            .child(versionID)
            .queryOrderedByKey()
            .queryEnding(beforeValue: lastKey)
            .queryLimited(toLast: 7)
        
        
        path.observeSingleEvent(of: .value) { snapshot in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(.readError))
                return
            }
            
            var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
            
            allObjects.forEach { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let receipt = Receipt(receiptID: snapshot.key,
                                          dictionary: dict)
                    receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                }
            }
            // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 설정
            receiptsTupleArray.reverse()
            
            // 더 이상 데이터가 없으면 lastKey를 업데이트하지 않고 종료
            if receiptsTupleArray.isEmpty {
                completion(.failure(.noMoreData))
            } else {
                if let lastSnapshot = allObjects.first {
                    self.roomLastKey = lastSnapshot.key
                }
                completion(.success(receiptsTupleArray))
            }
        }
    }
    
    // MARK: - 옵저버 설정
    func observeRoomReceipts(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        let path = RECEIPT_REF
            .child(versionID)
            .queryOrderedByKey()
        
        // 쿼리 설정
        let query: DatabaseQuery
        
        if let lastKey = self.roomLastKey, !lastKey.isEmpty {
            query = path
                .queryStarting(atValue: lastKey)
        } else {
            // lastKey가 유효하지 않은 경우 처음 7개의 데이터를 가져옴
            query = path
                .queryLimited(toFirst: 7)
        }
        
        query.observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let receiptID = snapshot.key
                
                let receipt = Receipt(receiptID: receiptID,
                                      dictionary: dict)
                let receiptTuple = (receiptID: receiptID, receipt: receipt)
                
                completion(.success(.added([receiptTuple])))
            } else {
                completion(.failure(.readError))
            }
        }
        
        // childChanged와 childRemoved는 그대로 유지
        path.observe(.childChanged) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
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
