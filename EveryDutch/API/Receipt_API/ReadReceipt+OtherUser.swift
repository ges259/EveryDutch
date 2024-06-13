//
//  ReadReceipt+OtherUser.swift
//  EveryDutch
//
//  Created by 계은성 on 6/13/24.
//

import Foundation
import FirebaseDatabaseInternal

extension ReceiptAPI {
    // MARK: - 초기 데이터 fetch
    func loadInitialUserReceipts(
        userID: String,
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    ) {
        let path = USER_RECEIPTS_REF
            .child(userID)
            .queryLimited(toLast: 6)
        
        
        path.observeSingleEvent(of: .value) { snapshot in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(.readError))
                return
            }
            
            var receiptIDs = [String]()
            
            allObjects.forEach { snapshot in
                receiptIDs.append(snapshot.key)
            }
            
            // Save the last key for future fetches
            if let lastSnapshot = allObjects.last {
                self.userLastKey = lastSnapshot.key
            }
            
            // Fetch receipt details
            self.fetchUserReceipts(versionID: versionID,
                                   receiptIDs: receiptIDs,
                                   completion: completion)
        }
    }
    
    // MARK: - 추가 데이터 fetch
    func loadMoreReceipts(
        userID: String,
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    ) {
        guard let lastKey = self.userLastKey else {
            completion(.failure(.noMoreData))
            return
        }
        
        let path = USER_RECEIPTS_REF
            .child(userID)
            .queryOrderedByKey()
            .queryEnding(atValue: lastKey)
            .queryLimited(toLast: 7)
        
        
        path.observeSingleEvent(of: .value) { snapshot in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(.readError))
                return
            }
            
            var receiptIDs = [String]()
            
            // Skip the last key as it is already fetched
            for i in 0..<allObjects.count {
                if allObjects[i].key != lastKey {
                    receiptIDs.append(allObjects[i].key)
                }
            }
            
            // Save the new last key for future fetches
            if let lastSnapshot = allObjects.first(where: { $0.key != lastKey }) {
                self.userLastKey = lastSnapshot.key
            }
            
            // Fetch receipt details
            self.fetchUserReceipts(versionID: versionID,
                                   receiptIDs: receiptIDs,
                                   completion: completion)
        }
    }
    
    // MARK: - 데이터 가져오기
    private func fetchUserReceipts(
        versionID: String,
        receiptIDs: [String],
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    ) {
        
        let receiptsRef = RECEIPT_REF.child(versionID)
        
        
        var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
        let group = DispatchGroup()
        
        receiptIDs.forEach { receiptID in
            group.enter()
            
            receiptsRef
                .child(receiptID)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    if let dict = snapshot.value as? [String: Any] {
                        let receipt = Receipt(dictionary: dict)
                        receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            completion(.success(receiptsTupleArray))
        }
    }
}
