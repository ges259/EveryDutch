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
//    func readRoomReceipts(
//        versionID: String,
//        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
//    ) {
//        let path = RECEIPT_REF
//            .child(versionID)
//            .queryOrdered(byChild: "date")
//            .queryLimited(toLast: 7)
//        
//        path.observeSingleEvent(of: .value) { snapshot in
//            
//            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
//                completion(.failure(.readError))
//                return
//            }
//            var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
//            
//            allObjects.forEach { snapshot in
//                if let dict = snapshot.value as? [String: Any] {
//                    let receipt = Receipt(receiptID: snapshot.key,
//                                          dictionary: dict)
//                    receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
//                }
//            }
//            
//            // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 함
//            receiptsTupleArray.reverse()
//            
//            // 마지막 항목의 키를 저장
//            if let lastSnapshot = allObjects.first {
//                self.roomLastKey = lastSnapshot.key
//                self.roomLastDate = (lastSnapshot.value as? [String: Any])?["date"] as? Double
//            }
//            completion(.success(.added(receiptsTupleArray)))
//            
//            if !self.observing {
//                self.observeRoomReceipts(versionID: versionID, completion: completion)
//                self.observing = true
//            }
//        }
//    }
//    
//    // MARK: - 추가 데이터 fetch
//    func loadMoreRoomReceipts(
//        versionID: String,
//        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
//    ) {
//        guard let lastDate = self.roomLastDate else {
//            completion(.failure(.noMoreData))
//            return
//        }
//        
//        print(#function)
//        let path = RECEIPT_REF
//            .child(versionID)
//            .queryOrdered(byChild: "date")
//            .queryEnding(beforeValue: lastDate)
//            .queryLimited(toLast: 7)
//        
//        path.observeSingleEvent(of: .value) { snapshot in
//            
//            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
//                completion(.failure(.readError))
//                return
//            }
//            
//            var receiptsTupleArray = [(receiptID: String, receipt: Receipt)]()
//            
//            allObjects.forEach { snapshot in
//                if let dict = snapshot.value as? [String: Any] {
//                    let receipt = Receipt(receiptID: snapshot.key,
//                                          dictionary: dict)
//                    receiptsTupleArray.append((receiptID: snapshot.key, receipt: receipt))
//                }
//            }
//            // 데이터를 순서대로 유지하여 최신 데이터가 마지막에 오도록 설정
//            receiptsTupleArray.reverse()
//            
//            // 더 이상 데이터가 없으면 lastKey를 업데이트하지 않고 종료
//            if receiptsTupleArray.isEmpty {
//                completion(.failure(.noMoreData))
//            } else {
//                if let lastSnapshot = allObjects.first {
//                    self.roomLastKey = lastSnapshot.key
//                    self.roomLastDate = (lastSnapshot.value as? [String: Any])?["date"] as? Double
//                }
//                completion(.success(receiptsTupleArray))
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    // MARK: - 옵저버 설정
//    private func observeRoomReceipts(
//        versionID: String,
//        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
//    ) {
//        let path = RECEIPT_REF
//            .child(versionID)
//            .queryOrdered(byChild: "date")
//        
//        // 쿼리 설정
//        var query: DatabaseQuery = path
//        
//        if let lastDate = self.roomLastDate {
//            query = path
//                .queryStarting(atValue: lastDate)
//            
//        } else {
//            // lastKey가 유효하지 않은 경우 처음 7개의 데이터를 가져옴
//            query = path
//            .queryOrdered(byChild: "date")
//            .queryLimited(toLast: 7)
//        }
//        
//        query.observe(.childAdded) { snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                let receiptID = snapshot.key
//                
//                let receipt = Receipt(receiptID: receiptID,
//                                      dictionary: dict)
//                let receiptTuple = (receiptID: receiptID, receipt: receipt)
//                
//                completion(.success(.added([receiptTuple])))
//            } else {
//                completion(.failure(.readError))
//            }
//        }
//        
//        // childChanged와 childRemoved는 그대로 유지
//        path.observe(.childChanged) { snapshot in
//            if let dict = snapshot.value as? [String: Any] {
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
//    }
//    
//    
//    
//    
    
    
    
    
//    
//    // MARK: - 데이터 fetch 및 실시간 업데이트
//    func observeRoomReceipts(
//        versionID: String,
//        isInitialLoad: Bool = true,
//        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
//    ) {
//        print("\(#function) ----- 1")
//        let path = RECEIPT_REF.child(versionID).queryOrdered(byChild: "date")
//        
//        // 쿼리 설정
//        var query: DatabaseQuery
//        
//        if isInitialLoad {
//            print("\(#function) ----- initialLoad")
//            // 초기 로드: 처음 7개의 데이터를 가져옴
//            query = path.queryLimited(toLast: 7)
//        } else if let lastDate = self.roomLastDate {
//            print("\(#function) ----- roomLastDate")
//            // 추가 로드: lastDate 이후의 데이터를 가져오기 위해 observe를 설정
//            query = path
//                .queryEnding(atValue: lastDate)
//                .queryLimited(toFirst: 5)
//        } else {
//            print("\(#function) ----- else")
//            // lastDate가 유효하지 않은 경우 추가 로드를 수행할 수 없음
//            completion(.failure(.readError))
//            return
//        }
//        
//        // observeSingleEvent 또는 observe(.value) 대신 observe(.childAdded)를 사용하여 실시간 업데이트 처리
//        query.observe(.childAdded) { snapshot in
//            print("childAdded ----- 1")
//            print("data123 ----- \(snapshot.key)")
//            guard snapshot.exists() else {
//                print("childAdded ----- -111111")
//                // 데이터가 더 이상 없음을 알리는 방법: snapshot.exists()가 false일 경우
//                completion(.failure(.noMoreData))
//                return
//            }
//            print("childAdded ----- 2")
//            guard let dict = snapshot.value as? [String: Any] else {
//                print("childAdded ----- -222222")
//                completion(.failure(.readError))
//                return
//            }
//            
//            let receiptID = snapshot.key
//            let receipt = Receipt(receiptID: receiptID, dictionary: dict)
//            let receiptTuple = (receiptID: receiptID, receipt: receipt)
//            // 마지막 항목의 키와 날짜를 저장
//            if let newDate = dict["date"] as? Double {
//                if let currentLastDate = self.roomLastDate {
//                    // 현재의 roomLastDate와 비교하여 더 작은 값인 경우에만 업데이트
//                    if newDate < currentLastDate {
//                        self.roomLastDate = newDate
//                    }
//                } else {
//                    // roomLastDate가 nil인 경우에는 무조건 업데이트
//                    self.roomLastDate = newDate
//                }
//            }
//            print("roomLastDate : \(self.roomLastDate)")
//            
//            print("childAdded ----- 3")
//            completion(.success(.added([receiptTuple])))
//        }
//        
//        path.observe(.childChanged) { snapshot in
//            if let dict = snapshot.value as? [String: Any] {
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
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    
//    func readRoomReceipts(
//        versionID: String,
//        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
//    ) {
//        let path = RECEIPT_REF
//            .child(versionID)
//            .queryOrdered(byChild: "date")
//            .queryLimited(toLast: 7)
//        
//        path.observe(.childAdded) { snapshot in
//            guard let dict = snapshot.value as? [String: Any] else {
//                completion(.failure(.readError))
//                return
//            }
//            
//            let receiptID = snapshot.key
//            let receipt = Receipt(receiptID: receiptID, dictionary: dict)
//            let receiptTuple = (receiptID: receiptID, receipt: receipt)
//            
//            // 저장된 마지막 날짜 업데이트
//            self.saveLastDate(dict)
//            
//            completion(.success(.added([receiptTuple])))
//        }
//    }
//
//    // MARK: - 추가 데이터 fetch
//    func loadMoreRoomReceipts(
//        versionID: String,
//        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
//    ) {
//        guard let lastDate = self.roomLastDate else {
//            completion(.failure(.noMoreData))
//            return
//        }
//        
//        let path = RECEIPT_REF
//            .child(versionID)
//            .queryOrdered(byChild: "date")
//            .queryEnding(beforeValue: lastDate)
//            .queryLimited(toLast: 7)
//        
//        path.observe(.childAdded) { snapshot in
//            guard let dict = snapshot.value as? [String: Any] else {
//                completion(.failure(.readError))
//                return
//            }
//            
//            let receiptID = snapshot.key
//            let receipt = Receipt(receiptID: receiptID, dictionary: dict)
//            let receiptTuple = (receiptID: receiptID, receipt: receipt)
//            
//            // 저장된 마지막 날짜 업데이트
//            self.saveLastDate(dict)
//            
//            completion(.success([receiptTuple]))
//        }
//    }
//    
//    private func saveLastDate(_ dict: [String: Any]) {
//        if let newDate = dict["date"] as? Double {
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
    
    
    // MARK: - 데이터 fetch
    func observeRoomReceipts(
        versionID: String,
        isInitialLoad: Bool,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
    ) {
        let path = RECEIPT_REF.child(versionID).queryOrdered(byChild: "date")
        
        var query: DatabaseQuery
        
        if isInitialLoad {
            query = path.queryLimited(toLast: 7)
        } else {
            guard let lastDate = self.roomLastDate else {
                completion(.failure(.noMoreData))
                return
            }
            query = path.queryEnding(beforeValue: lastDate).queryLimited(toLast: 7)
        }
        
        query.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            let receiptID = snapshot.key
            let receipt = Receipt(receiptID: receiptID, dictionary: dict)
            let receiptTuple = (receiptID: receiptID, receipt: receipt)
            
            // 저장된 마지막 날짜 업데이트
            self.updateLastDate(with: dict)
            
            completion(.success(.added([receiptTuple])))
        }
    }

    // 마지막 날짜 저장 함수
    private func updateLastDate(with dict: [String: Any]) {
        if let newDate = dict["date"] as? Double {
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
