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
    func readReceipts(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryLimited(toLast: 6)
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
                
                // 마지막 항목의 키와 날짜를 저장
                if let lastSnapshot = allObjects.first {
                    if let date = lastSnapshot.childSnapshot(forPath: DatabaseConstants.date).value as? Int {
                        self.lastKey = lastSnapshot.key
                        self.lastDate = date
                    }
                }
                completion(.success(.initialLoad(receiptsTupleArray)))
                
                if !self.observing {
                    self.observeReceipt(versionID: versionID, completion: completion)
                    self.observing = true
                }
            }
    }
    
    // MARK: - 추가 데이터 fetch
    func loadMoreReceipts(
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    ) {
        RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
            .queryEnding(beforeValue: self.lastDate)
            .queryLimited(toLast: 7)
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
                // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 설정
                receiptsTupleArray.reverse()
                
                // 더 이상 데이터가 없으면 lastKey를 업데이트하지 않고 종료
                if receiptsTupleArray.isEmpty {
                    completion(.failure(.noMoreData))
                } else {
                    if let lastSnapshot = allObjects.first {
                        if let date = lastSnapshot.childSnapshot(forPath: DatabaseConstants.date).value as? Int {
                            self.lastKey = lastSnapshot.key
                            self.lastDate = date
                        }
                    }
                    completion(.success(receiptsTupleArray))
                }
            }
    }
    
    // MARK: - 옵저버 설정
    func observeReceipt(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        let path = RECEIPT_REF.child(versionID)
        
        // 쿼리 설정
        let query: DatabaseQuery
        
        if let lastDate = self.lastDate, lastDate != 0, let lastKey = self.lastKey, !lastKey.isEmpty {
            query = path
                .queryOrdered(byChild: DatabaseConstants.date)
                .queryStarting(atValue: lastDate, childKey: lastKey)
        } else {
            // lastDate와 lastKey가 유효하지 않은 경우 처음 7개의 데이터를 가져옴
            query = path
                .queryOrdered(byChild: DatabaseConstants.date)
                .queryLimited(toFirst: 7)
        }
        
        query.observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let receiptID = snapshot.key
                
                let receipt = Receipt(dictionary: dict)
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
