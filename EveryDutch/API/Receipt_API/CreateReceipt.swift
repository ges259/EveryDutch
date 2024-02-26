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
    
    // MARK: - 공통 재시도 로직
    private func retryWithDelay(
        _ retryCount: Int,
        operation: @escaping (Int) -> Void)
    {
        guard retryCount < self.maxRetryCount else { return }
        
        // 지수 백오프를 적용한 지연 시간 계산
        let delay = pow(2.0, Double(retryCount)) * self.retryDelay
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            operation(retryCount + 1)
        }
    }
    
    // MARK: - 영수증 만들기
    func createReceipt(
        versionID: String, 
        dictionary: [String: Any?],
        retryCount: Int = 0,
        completion: @escaping Typealias.CreateReceiptCompletion) 
    {
        // value에 nil이 있으면 삭제.
        var dict = dictionary.compactMapValues { $0 }
        
        // 경로 설정
        let path = RECEIPT_REF
            .child(versionID)
            .childByAutoId()
        
        // 데이터 저장
        path.setValue(dict) { [weak self] error, ref in
            guard let self = self else { return }
            
            // 에러가 있다면
            if let error = error {
                
                // 재시도 (최대 3회)
                if retryCount < self.maxRetryCount {
                    self.retryWithDelay(retryCount) { newRetryCount in
                        self.createReceipt(
                            versionID: versionID,
                            dictionary: dictionary, 
                            retryCount: newRetryCount,
                            completion: completion)
                    }
                    // 3회 재시도를 해도, 에러인 상태일 때.
                    // 로그 저장
                } else {
                    // 버전 ID 로그 저장을 위해 딕셔너리에 추가
                    dict["versionID"] = versionID
                    // 로그 저장
                    self.logError(
                        error,
                        withAdditionalInfo: dict,
                        functionName: #function)
                    
                    completion(.failure(.readError))
                }
                
            } else if let receiptKey = ref.key {
                completion(.success(receiptKey))
                
                
            } else {
                completion(.failure(.readError))
            }
        }
    }
    
    // MARK: - 유저의 영수증 저장
    func saveReceiptForUsers(
        receiptID: String,
        users: [String],
        retryCount: Int = 0,
        completion: @escaping Typealias.baseCompletion)
    {
        let saveGroup = DispatchGroup()
        
        // 성공한 데이터
        var successData = [String]()
        
        users.forEach { userID in
            saveGroup.enter()
            let path = USER_RECEIPTS_REF.child(userID)
            
            path.updateChildValues([receiptID: true]) { [weak self] error, _ in
                guard let self = self else { return }
                
                if let error = error {
                    if retryCount < self.maxRetryCount {
                        self.retryWithDelay(retryCount) { newRetryCount in
                            self.saveReceiptForUsers(
                                receiptID: receiptID,
                                users: users,
                                retryCount: newRetryCount,
                                completion: completion)
                        }
                        
                    } else {
                        
                        let dict: [String: Any] = [
                            "originalData": users,
                            "successData": successData,
                            "receiptID": receiptID]
                        
                        self.logError(
                            error,
                            withAdditionalInfo: dict,
                            functionName: #function)
                        
                        completion(.failure(.readError))
                    }
                }
                
                successData.append(userID)
                saveGroup.leave()
            }
        }
        
        saveGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    // MARK: - 누적 금액 업데이트
    func updateCumulativeMoney(
        versionID: String,
        usersMoneyDict: [String: Int],
        retryCount: Int = 0,
        completion: @escaping Typealias.baseCompletion)
    {
        self.performTransactionUpdate(
            forRef: Cumulative_AMOUNT_REF.child(versionID),
            withDict: usersMoneyDict,
            retryCount: retryCount,
            completion: completion)
    }
    
    // MARK: - 페이백 업데이트
    func updatePayback(
        versionID: String,
        payerID: String,
        usersMoneyDict: [String: Int],
        retryCount: Int = 0,
        completion: @escaping Typealias.baseCompletion)
    {
        self.performTransactionUpdate(
            forRef: PAYBACK_REF.child(versionID).child(payerID),
            withDict: usersMoneyDict,
            retryCount: retryCount,
            completion: completion)
    }
    
    // MARK: - 트랜잭션 업데이트를 위한 공통 함수
//    private func performTransactionUpdate2(
//        forRef reference: DatabaseReference,
//        withDict usersMoneyDict: [String: Int],
//        retryCount: Int = 0,
//        completion: @escaping Typealias.baseCompletion)
//    {
//        print("Transaction updates started.")
//        var retryDict = usersMoneyDict
//        let group = DispatchGroup()
//
//        for (userID, amount) in usersMoneyDict {
//            group.enter()
//
//            let userRef = reference.child(userID)
//            userRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
//                if let value = currentData.value as? Double {
//                    print("1")
//                    let newValue = value + Double(amount)
//                    currentData.value = newValue
//                    return .success(withValue: currentData)
//                } else if currentData.value is NSNull || currentData.value == nil {
//                    print("2")
//                    currentData.value = Double(amount)
//                    return .success(withValue: currentData)
//                } else {
//                    print("--------------error1")
//                    // 타입 캐스팅 실패 시, 에러 로그를 남기고 실패 반환
//                    let errorInfo: [String: Any] = [
//                        "userID": userID,
//                        "attemptedToAddAmount": amount,
//                        "existingValue": currentData.value ?? "nil"
//                    ]
//                    self.logError(
//                        ErrorEnum.readError,
//                        withAdditionalInfo: errorInfo,
//                        functionName: #function)
//                    return TransactionResult.abort()
//                }
//            }, andCompletionBlock: { [weak self] error, committed, _ in
//                if let error = error {
//                    print("3")
//                    print("--------------error2")
//                    // 에러 발생 시 로깅
//                    let errorInfo: [String: Any] = [
//                        "originalData": usersMoneyDict,
//                        "failedData": retryDict,
//                        "failedUserID": userID,
//                        "failedamount": amount
//                    ]
//                    // 로그에 남길 실패한 userID 기록
//                    self?.logError(
//                        error,
//                        withAdditionalInfo: errorInfo,
//                        functionName: #function)
//                    
//                    retryDict[userID] = amount
//                }
//                if committed {
//                    print("4")
//                    retryDict.removeValue(forKey: userID)
//                }
//                print("5")
//                group.leave()
//            })
//        }
//
//        group.notify(queue: .main) { [weak self] in
//            if !retryDict.isEmpty && retryCount < (self?.maxRetryCount ?? 0) {
//                self?.retryWithDelay(retryCount) {
//                    self?.performTransactionUpdate(forRef: reference, withDict: retryDict, retryCount: $0, completion: completion)
//                }
//            } else {
//                let result = retryDict.isEmpty ? Result.success(()) : Result.failure(ErrorEnum.readError)
//                completion(result)
//            }
//        }
//    }
    
    
    
    
    func performTransactionUpdate(
        forRef reference: DatabaseReference,
        withDict usersMoneyDict: [String: Int],
        retryCount: Int = 0,
        completion: @escaping (Result<Void, ErrorEnum>) -> Void)
    {
        print("Transaction updates started.")
        self.retryDict = usersMoneyDict
        let group = DispatchGroup()

        for (userID, amount) in usersMoneyDict {
            group.enter()
            let userRef = reference.child(userID)
            self.updateAmount(forUserRef: userRef,
                         userID: userID,
                         amount: amount,
                         group: group)
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if !self.retryDict.isEmpty && retryCount < self.maxRetryCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                    self.performTransactionUpdate(
                        forRef: reference,
                        withDict: self.retryDict,
                        retryCount: retryCount + 1,
                        completion: completion)
                }
                
            } else if self.retryDict.isEmpty {
                completion(.success(()))
            } else {
                // Define and use a specific error for max retry count exceeded
                completion(.failure(.readError))
            }
        }
    }

    private func updateAmount(
        forUserRef userRef: DatabaseReference,
        userID: String,
        amount: Int,
        group: DispatchGroup)
    {
        userRef.runTransactionBlock(
            { (currentData: MutableData) -> TransactionResult in
                let currentValue = (currentData.value as? Double) ?? 0
                let updatedValue = currentValue + Double(amount)
                currentData.value = updatedValue
                return TransactionResult.success(withValue: currentData)
                
            }) { [weak self] error, committed, _ in
                guard let self = self else { return }
                if committed {
                    self.retryDict.removeValue(forKey: userID)
                } else if let error = error {
                    // 에러 발생 시 로깅
                    let errorInfo: [String: Any] = [
                        "userID": userID,
                        "attemptedToAddAmount": amount,
                        "originalData": self.retryDict,
                        "failedUserID": userID,
                        "failedAmount": amount
                    ]
                    self.logError(
                        error,
                        withAdditionalInfo: errorInfo,
                        functionName: #function)
                }
                group.leave()
            }
    }
}
