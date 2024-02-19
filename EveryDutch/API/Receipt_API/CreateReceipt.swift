//
//  CreateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase
import FirebaseCrashlytics


protocol CrashlyticsLoggable {
    func logError(
        _ error: Error,
        withAdditionalInfo info: [String: Any],
        functionName: String)
}

extension CrashlyticsLoggable {
    func logError(
        _ error: Error,
        withAdditionalInfo info: [String: Any] = [:],
        functionName: String = #function)
    {
        print("Error encountered: \(error.localizedDescription)")
        
        // 기본 오류 메시지 로그
        Crashlytics
            .crashlytics()
            .log("Error in \(functionName): \(error.localizedDescription)")
        
        // 추가 정보 로그
        info.forEach { key, value in
            Crashlytics
                .crashlytics()
                .setCustomValue(value, forKey: key)
        }
    }
}



// Create
    // Receipt에 데이터 저장 ----- (Receipt)
    // 개인적으로 데이터 저장 ----- (User_Receipt)

class ReceiptAPI: ReceiptAPIProtocol, CrashlyticsLoggable {
    static let shared: ReceiptAPIProtocol = ReceiptAPI()
    private init() {}
    
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
    // - 롤백을 위해 저장되는 데이터들
    // versionID: String
    // receiptID: String
    // payerID: String// payerID: String
    // users: [String]
    // usersMoneyDict: [String: Int]
    // retryUsersMoneyDict: [String: Int]
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
                    print("Error saving user receipt mapping: \(error.localizedDescription)")
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
    private func performTransactionUpdate(
        forRef reference: DatabaseReference,
        withDict usersMoneyDict: [String: Int],
        retryCount: Int,
        completion: @escaping Typealias.baseCompletion)
    {
        // 성공한 데이터를 하나씩 제거 (== 아직 저장되지 않은 데이터들.)
        var retryDict = usersMoneyDict
        let group = DispatchGroup()
        
        for (userID, amount) in usersMoneyDict {
            group.enter()
            
            let path = reference.child(userID)
            path.runTransactionBlock(
                { (currentData: MutableData) -> TransactionResult in
                    
                    var value = currentData.value as? Int ?? 0
                    
                    value += amount
                    
                    currentData.value = value
                    
                    return TransactionResult.success(withValue: currentData)
                    
                }) { [weak self] error, _, _ in
                    
                    
                    // 에러가 있다면
                    if let error = error {
                        
                        // 로그에 남길 실패한 userID 기록
                        self?.logError(
                            error,
                            withAdditionalInfo: [
                                "originalData": usersMoneyDict,
                                "failedData": retryDict,
                                "failedUserID": userID,
                                "failedamount": amount],
                            functionName: #function)
                        
                    // 에러가 없으면 성공으로 간주하고,
                    } else {
                        // retryDict에서 해당 사용자를 제거합니다.
                        retryDict.removeValue(forKey: userID)
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // retryDict에 남아 있는 항목이 있으면 재시도합니다.
            if !retryDict.isEmpty
                && retryCount >= self.maxRetryCount
            {
                
                self.retryWithDelay(retryCount) { newRetryCount in
                    self.performTransactionUpdate(
                        forRef: reference,
                        withDict: retryDict,
                        retryCount: newRetryCount,
                        completion: completion)
                }
            } else {
                // 모든 항목이 성공적으로 처리되었으면, 성공을 반환합니다.
                completion(.success(()))
            }
        }
    }
}
