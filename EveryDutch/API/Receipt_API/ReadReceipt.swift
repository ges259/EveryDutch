//
//  Receipt_API.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabaseInternal

//// Read
//// Receipt에서 데이터 가져오기 ----- (Receipt)
//extension ReceiptAPI {
//
//    func observeRoomReceipts(
//        versionID: String,
//        isInitialLoad: Bool,
//        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
//    ) {
//        let path = RECEIPT_REF
//            .child(versionID)
//            .queryOrdered(byChild: DatabaseConstants.date)
//        
//        var query: DatabaseQuery
//        
//        if isInitialLoad {
//            query = path.queryLimited(toLast: 7)
//        } else {
//            guard let lastDate = self.roomLastDate else {
//                completion(.failure(.noMoreData))
//                return
//            }
//            query = path
//                .queryEnding(beforeValue: lastDate)
//                .queryLimited(toLast: 3)
//        }
//
//        query.observe(.childAdded) { snapshot in
//            print("childAdded ----- \(snapshot.key)")
//            guard let dict = snapshot.value as? [String: Any] else {
//                completion(.failure(.readError))
//                return
//            }
//            let receiptID = snapshot.key
//            let receipt = Receipt(receiptID: receiptID, dictionary: dict)
//            let receiptTuple = (receiptID: receiptID, receipt: receipt)
//            
//            if self.existingReceiptIDs.contains(receiptID) {
//                // 이미 존재하는 항목이므로 업데이트로 처리
//                completion(.success(.updated([receiptID: dict])))
//            } else {
//                // 새로운 항목이므로 추가로 처리
//                self.existingReceiptIDs.insert(receiptID)
//                // 저장된 마지막 날짜 업데이트
//                self.updateLastDate(with: dict)
//                completion(.success(.added([receiptTuple])))
//            }
//        }
//        
//        query.observe(.childChanged) { snapshot in
//            print("childChanged")
//            
//            if let dict = snapshot.value as? [String: Any] {
//                print("childChanged ----- \(dict)")
//                completion(.success(.updated([snapshot.key: dict])))
//            } else {
//                completion(.failure(.readError))
//            }
//        }
//        path.observe(.childRemoved) { snapshot in
//            let receiptID = snapshot.key
//            self.existingReceiptIDs.remove(receiptID)
//            completion(.success(.removed(receiptID)))
//        }
//        path.observe(.childRemoved) { snapshot in
//            let receiptID = snapshot.key
//            completion(.success(.removed(receiptID)))
//        }
//    }
//
//    private func updateLastDate(with dict: [String: Any]) {
//        if let newDate = dict[DatabaseConstants.date] as? Double {
//            if let currentLastDate = self.roomLastDate {
//                // 현재의 roomLastDate와 비교하여 더 작은 값인 경우에만 업데이트
//                if newDate < currentLastDate {
//                    self.roomLastDate = newDate
//                }
//            } else {
//                // roomLastDate가 nil인 경우에는 무조건 업데이트
//                self.roomLastDate = newDate
//            }
//        }
//    }
//}


// Read
// Receipt에서 데이터 가져오기 ----- (Receipt)
extension ReceiptAPI {

    func observeRoomReceipts(
        versionID: String,
        isInitialLoad: Bool,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        let path = RECEIPT_REF
            .child(versionID)
            .queryOrdered(byChild: DatabaseConstants.date)
        
        var query: DatabaseQuery
        
        if isInitialLoad {
            query = path.queryLimited(toLast: 7)
        } else {
            guard let lastDate = self.roomLastDate else {
                completion(.failure(.noMoreData))
                return
            }
            query = path
                .queryEnding(beforeValue: lastDate)
                .queryLimited(toLast: 3)
        }

        query.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            let receiptID = snapshot.key
            let receipt = Receipt(receiptID: receiptID, dictionary: dict)
            let receiptTuple = (receiptID: receiptID, receipt: receipt)
            
            if self.existingReceiptIDs.contains(receiptID) {
                // 이미 존재하는 항목이므로 업데이트로 처리
                completion(.success(.updated([receiptID: dict])))
            } else {
                // 새로운 항목이므로 추가로 처리
                self.existingReceiptIDs.insert(receiptID)
                // 저장된 마지막 날짜 업데이트
                self.updateLastDate(with: dict)
                completion(.success(.added([receiptTuple])))
            }
        }
        
        query.observe(.childChanged) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                completion(.success(.updated([snapshot.key: dict])))
            } else {
                completion(.failure(.readError))
            }
        }
        
        path.observe(.childMoved) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                completion(.success(.updated([snapshot.key: dict])))
            } else {
                completion(.failure(.readError))
            }
        }

        path.observe(.childRemoved) { snapshot in
            let receiptID = snapshot.key
            self.existingReceiptIDs.remove(receiptID)
            completion(.success(.removed(receiptID)))
        }
    }

    private func handleSnapshot(
        _ snapshot: DataSnapshot,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        guard let dict = snapshot.value as? [String: Any] else {
            completion(.failure(.readError))
            return
        }
        let receiptID = snapshot.key
        let receipt = Receipt(receiptID: receiptID, dictionary: dict)
        let receiptTuple = (receiptID: receiptID, receipt: receipt)
        
        if self.existingReceiptIDs.contains(receiptID) {
            // 이미 존재하는 항목이므로 업데이트로 처리
            completion(.success(.updated([receiptID: dict])))
            
        } else {
            // 새로운 항목이므로 추가로 처리
            self.existingReceiptIDs.insert(receiptID)
            self.updateLastDate(with: dict)
            completion(.success(.added([receiptTuple])))
        }
    }

    private func updateLastDate(with dict: [String: Any]) {
        if let newDate = dict[DatabaseConstants.date] as? Double {
            if let currentLastDate = self.roomLastDate {
                // 현재의 roomLastDate와 비교하여 더 작은 값인 경우에만 업데이트
                if newDate < currentLastDate {
                    self.roomLastDate = newDate
                }
            } else {
                // roomLastDate가 nil인 경우에는 무조건 업데이트
                self.roomLastDate = newDate
            }
        }
    }
}
