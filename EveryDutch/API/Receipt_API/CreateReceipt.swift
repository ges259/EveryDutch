//
//  CreateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase

// Create
    // Receipt에 데이터 저장 ----- (Receipt)
    // 개인적으로 데이터 저장 ----- (User_Receipt)

class ReceiptAPI: ReceiptAPIProtocol, CrashlyticsLoggable {
    static let shared: ReceiptAPIProtocol = ReceiptAPI()
    private init() {}
    
    private var retryDict: [String: Int] = [:]
    
    private let maxRetryCount = 3 // 최대 재시도 횟수 설정
    private let retryDelay = 2.0 // 재시도 간 지연 시간(초)
}


    // ************************************
    // - 비동기 작업 순서
    // 1. 누적 금액 업데이트
    // 2. 페이백 업데이트
    // 3. 영수증 만들기
    // 4. 유저의 영수증 저장
    // ************************************


extension ReceiptAPI {
    
//    // MARK: - 공통 재시도 로직
//    private func retryWithDelay(
//        _ retryCount: Int,
//        operation: @escaping (Int) -> Void)
//    {
//        guard retryCount < self.maxRetryCount else { return }
//        
//        // 지수 백오프를 적용한 지연 시간 계산
//        let delay = pow(2.0, Double(retryCount)) * self.retryDelay
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            operation(retryCount + 1)
//        }
//    }
//    
//    // MARK: - 영수증 만들기
//    func createReceipt(
//        versionID: String, 
//        dictionary: [String: Any?],
//        retryCount: Int = 0,
//        completion: @escaping Typealias.CreateReceiptCompletion) 
//    {
//        // value에 nil이 있으면 삭제.
//        var dict = dictionary.compactMapValues { $0 }
//        
//        // 경로 설정
//        let path = RECEIPT_REF
//            .child(versionID)
//            .childByAutoId()
//        
//        // 데이터 저장
//        path.setValue(dict) { [weak self] error, ref in
//            guard let self = self else { return }
//            
//            // 에러가 있다면
//            if let error = error {
//                
//                // 재시도 (최대 3회)
//                if retryCount < self.maxRetryCount {
//                    self.retryWithDelay(retryCount) { newRetryCount in
//                        self.createReceipt(
//                            versionID: versionID,
//                            dictionary: dictionary, 
//                            retryCount: newRetryCount,
//                            completion: completion)
//                    }
//                    // 3회 재시도를 해도, 에러인 상태일 때.
//                    // 로그 저장
//                } else {
//                    // 버전 ID 로그 저장을 위해 딕셔너리에 추가
//                    dict["versionID"] = versionID
//                    // 로그 저장
//                    self.logError(
//                        error,
//                        withAdditionalInfo: dict,
//                        functionName: #function)
//                    
//                    completion(.failure(.readError))
//                }
//                
//            } else if let receiptKey = ref.key {
//                completion(.success(receiptKey))
//                
//                
//            } else {
//                completion(.failure(.readError))
//            }
//        }
//    }
//    
//    // MARK: - 유저의 영수증 저장
//    func saveReceiptForUsers(
//        receiptID: String,
//        users: [String],
//        retryCount: Int = 0,
//        completion: @escaping Typealias.VoidCompletion)
//    {
//        let saveGroup = DispatchGroup()
//        
//        // 성공한 데이터
//        var successData = [String]()
//        
//        users.forEach { userID in
//            saveGroup.enter()
//            let path = USER_RECEIPTS_REF.child(userID)
//            
//            path.updateChildValues([receiptID: true]) { [weak self] error, _ in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    if retryCount < self.maxRetryCount {
//                        self.retryWithDelay(retryCount) { newRetryCount in
//                            self.saveReceiptForUsers(
//                                receiptID: receiptID,
//                                users: users,
//                                retryCount: newRetryCount,
//                                completion: completion)
//                        }
//                        
//                    } else {
//                        
//                        let dict: [String: Any] = [
//                            "originalData": users,
//                            "successData": successData,
//                            "receiptID": receiptID]
//                        
//                        self.logError(
//                            error,
//                            withAdditionalInfo: dict,
//                            functionName: #function)
//                        
//                        completion(.failure(.readError))
//                    }
//                }
//                
//                successData.append(userID)
//                saveGroup.leave()
//            }
//        }
//        
//        saveGroup.notify(queue: .main) {
//            completion(.success(()))
//        }
//    }
//    
//    // MARK: - 누적 금액 업데이트
//    func updateCumulativeMoney(
//        versionID: String,
//        usersMoneyDict: [String: Int],
//        retryCount: Int = 0,
//        completion: @escaping Typealias.VoidCompletion)
//    {
//        self.performTransactionUpdate(
//            forRef: Cumulative_AMOUNT_REF.child(versionID),
//            withDict: usersMoneyDict,
//            retryCount: retryCount,
//            completion: completion)
//    }
//    
//    // MARK: - 페이백 업데이트
//    func updatePayback(
//        versionID: String,
//        payerID: String,
//        usersMoneyDict: [String: Int],
//        retryCount: Int = 0,
//        completion: @escaping Typealias.VoidCompletion)
//    {
//        self.performTransactionUpdate(
//            forRef: PAYBACK_REF.child(versionID).child(payerID),
//            withDict: usersMoneyDict,
//            retryCount: retryCount,
//            completion: completion)
//    }
//    
//    // MARK: - 트랜잭션 업데이트를 위한 공통 함수
//    func performTransactionUpdate(
//        forRef reference: DatabaseReference,
//        withDict usersMoneyDict: [String: Int],
//        retryCount: Int = 0,
//        completion: @escaping (Result<Void, ErrorEnum>) -> Void)
//    {
//        print("Transaction updates started.")
//        self.retryDict = usersMoneyDict
//        let group = DispatchGroup()
//
//        for (userID, amount) in usersMoneyDict {
//            group.enter()
//            let userRef = reference.child(userID)
//            self.updateAmount(forUserRef: userRef,
//                         userID: userID,
//                         amount: amount,
//                         group: group)
//        }
//
//        group.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            if !self.retryDict.isEmpty && retryCount < self.maxRetryCount {
//                DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
//                    self.performTransactionUpdate(
//                        forRef: reference,
//                        withDict: self.retryDict,
//                        retryCount: retryCount + 1,
//                        completion: completion)
//                }
//                
//            } else if self.retryDict.isEmpty {
//                completion(.success(()))
//            } else {
//                // Define and use a specific error for max retry count exceeded
//                completion(.failure(.readError))
//            }
//        }
//    }
//
//    private func updateAmount(
//        forUserRef userRef: DatabaseReference,
//        userID: String,
//        amount: Int,
//        group: DispatchGroup)
//    {
//        userRef.runTransactionBlock(
//            { (currentData: MutableData) -> TransactionResult in
//                let currentValue = (currentData.value as? Double) ?? 0
//                let updatedValue = currentValue + Double(amount)
//                currentData.value = updatedValue
//                return TransactionResult.success(withValue: currentData)
//                
//            }) { [weak self] error, committed, _ in
//                guard let self = self else { return }
//                if committed {
//                    self.retryDict.removeValue(forKey: userID)
//                } else if let error = error {
//                    // 에러 발생 시 로깅
//                    let errorInfo: [String: Any] = [
//                        "userID": userID,
//                        "attemptedToAddAmount": amount,
//                        "originalData": self.retryDict,
//                        "failedUserID": userID,
//                        "failedAmount": amount
//                    ]
//                    self.logError(
//                        error,
//                        withAdditionalInfo: errorInfo,
//                        functionName: #function)
//                }
//                group.leave()
//            }
//    }
}




























extension ReceiptAPI {
    
    // MARK: - 영수증 만들기
    func createReceipt(
        versionID: String,
        dictionary: [String: Any?]) async throws -> String
    {
        let path = RECEIPT_REF
            .child(versionID)
            .childByAutoId()
        let filteredDictionary = dictionary.compactMapValues { $0 }
        
        return try await withCheckedThrowingContinuation { continuation in
            path.setValue(filteredDictionary) { error, ref in
                if let error = error {
                    // 에러 로깅
                    let info = ["versionID": versionID,
                                "dictionaryKeys": filteredDictionary.keys.joined(separator: ", ")]
                    self.logError(error, 
                                  withAdditionalInfo: info,
                                  functionName: #function)
                    continuation.resume(throwing: ErrorEnum.readError)
                } else if let key = ref.key {
                    // 성공
                    continuation.resume(returning: key)
                } else {
                    // 알 수 없는 에러
                    continuation.resume(throwing: ErrorEnum.unknownError)
                }
            }
        }
    }
    
    // MARK: - 유저의 영수증 저장
    func saveReceiptForUsers(
        receiptID: String,
        users: [String]) async throws
    {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for user in users {
                group.addTask {
                    let path = USER_RECEIPTS_REF.child(user)
                    try await self.updateChildValues(path: path, values: [receiptID: true])
                }
            }
            try await group.waitForAll()
        }
    }
    
    // MARK: - 누적 금액 업데이트
    func updateCumulativeMoney(
        versionID: String,
        moneyDict: [String: Int]) async throws
    {
        let reference = Cumulative_AMOUNT_REF.child(versionID)
        try await performTransactionUpdate(forRef: reference, withDict: moneyDict)
    }
    
    // MARK: - 페이백 업데이트
    func updatePayback(
        versionID: String,
        payerID: String,
        moneyDict: [String: Int]) async throws
    {
        var paybackDict = moneyDict
            paybackDict.removeValue(forKey: payerID)
        let reference = PAYBACK_REF.child(versionID).child(payerID)
        try await performTransactionUpdate(forRef: reference, withDict: paybackDict)
    }
    
    // MARK: - 트랜잭션 업데이트를 위한 공통 함수
    private func performTransactionUpdate(
        forRef reference: DatabaseReference,
        withDict moneyDict: [String: Int]) async throws
    {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for (userID, amount) in moneyDict {
                group.addTask {
                    let userRef = reference.child(userID)
                    try await self.updateAmount(forUserRef: userRef, amount: amount)
                }
            }
            try await group.waitForAll()
        }
    }
    
    private func updateAmount(
        forUserRef userRef: DatabaseReference,
        amount: Int) async throws
    {
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            userRef.runTransactionBlock { currentData in
                let currentValue = (currentData.value as? Double) ?? 0
                currentData.value = currentValue + Double(amount)
                return TransactionResult.success(withValue: currentData)
            } andCompletionBlock: { error, committed, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if committed {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: ErrorEnum.readError)
                }
            }
        }
    }
    
    private func updateChildValues(
        path: DatabaseReference,
        values: [String: Any]) async throws
    {
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            path.updateChildValues(values) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
