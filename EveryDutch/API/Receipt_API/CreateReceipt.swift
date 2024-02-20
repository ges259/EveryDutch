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
            // 작업 시작을 그룹에 알림
            group.enter()
            
            let path = reference.child(userID)
            
            path.runTransactionBlock( { (currentData: MutableData) -> TransactionResult in
                // 현재 데이터를 Int로 변환 시도
                if let value = currentData.value as? Int {
                    // 새로운 금액 계산
                    let newValue = value + amount
                    // 데이터 업데이트
                    currentData.value = newValue
                    // 성공 결과 반환
                    return TransactionResult.success(withValue: currentData)
                    
                } else {
                    // 타입 캐스팅 실패 시, 에러 로그를 남기고 실패 반환
                    let errorInfo: [String: Any] = [
                        "userID": userID,
                        "attemptedToAddAmount": amount,
                        "existingValue": currentData.value ?? "nil"
                    ]
                    self.logError(
                        ErrorEnum.readError,
                        withAdditionalInfo: errorInfo,
                        functionName: #function)
                    return TransactionResult.abort()
                }
                
            }) { [weak self] error, _, _ in
                if let error = error {
                    // 에러 발생 시 로깅
                    let errorInfo: [String: Any] = [
                        "originalData": usersMoneyDict,
                        "failedData": retryDict,
                        "failedUserID": userID,
                        "failedamount": amount
                    ]
                    
                    // 로그에 남길 실패한 userID 기록
                    self?.logError(
                        error,
                        withAdditionalInfo: errorInfo,
                        functionName: #function)
                    
                } else {
                    // 성공 시, 처리된 항목 제거
                    retryDict.removeValue(forKey: userID)
                }
                // 작업 완료를 그룹에 알림
                group.leave()
            }
        }
        
        // 모든 작업 완료 후 실행될 코드
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // 재시도할 항목이 남아있고, 최대 재시도 횟수에 도달하지 않았다면 재시도
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
                // 모든 항목이 성공적으로 처리되었거나, 최대 재시도 횟수에 도달했다면
                 if retryDict.isEmpty {
                     // 성공 콜백 호출
                     completion(.success(()))
                     
                 } else {
                     // 실패한 항목이 남아있다면 실패 콜백 호출
                     completion(.failure(.readError))
                 }
             }
         }
     }
}
