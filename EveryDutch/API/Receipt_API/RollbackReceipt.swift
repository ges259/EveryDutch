//
//  RollbackReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 2/16/24.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
struct RollbackResult {
    var success: Bool = true
    var originalData: [String: Any] // 원래 데이터
    var successData: [String: Any] // 성공한 데이터
    var failedData: [String: Any] // 실패한 데이터
}
enum RollBackReceiptEnum {
    case payback
    case cumulativeMoney
    case createReceipt
    case saveReceipt
    
    var description: String {
        switch self {
        case .payback: 
            return DatabaseConstants.payback
        case .cumulativeMoney: 
            return DatabaseConstants.culmulative_money
        case .createReceipt: 
            return DatabaseConstants.createReceipt
        case .saveReceipt: 
            return DatabaseConstants.saveReceipt
        }
    }
}

class RollbackDataManager {
    static let shared = RollbackDataManager()
    private init() {}
    
    // MARK: - 데이터 프로퍼티
    private var versionID: String?
    private var receiptID: String?
    private var usersIDArray: [String]?
    private var payerID: String?
    private var savedCumulativeMoneyDict: [String: Int]?
    private var savedPaybackDict: [String: Int]?
    
    // MARK: - 데이터 롤백 여부
    private var successCreateReceipt: Bool = false
    private var successSaveReceipt: Bool = false
    private var successCumulativeMoney: Bool = false
    private var successPayback: Bool = false
    
    // ************************************
    // - 비동기 작업 순서
    // 1. 영수증 만들기
    // 2. 유저의 영수증 저장
    // 3. 누적 금액 업데이트
    // 4. 페이백 업데이트
    // ************************************
    // - 롤백 작업 순서
    // 1. 페이백 업데이트 => (versionID --- payerID --- savedPaybackDict)
    // 2. 누적 금액 업데이트 => (versionID --- savedVumulativeMoneyDict)
    // 3. 유저의 영수증 저장 => (versionID --- receiptID)
    // 4. 영수증 만들기 => (usersIDArray --- receiptID)
    // ************************************
    
    
    // MARK: - 데이터 저장
    func setRollbackDataPayback(
        payerID: String,
        savedPaybackDict: [String: Int])
    {
        self.payerID = payerID
        self.savedPaybackDict = savedPaybackDict
        
        self.successPayback = true
    }
    func setRollbackDataCumulativeMoney(
        versionID: String,
        savedCumulativeMoneyDict: [String: Int])
    {
        self.versionID = versionID
        self.savedCumulativeMoneyDict = savedCumulativeMoneyDict
        
        self.successCumulativeMoney = true
    }
    func setRollbackDataSaveReceiptForUsers(usersIDArray: [String]) {
        self.usersIDArray = usersIDArray
        
        self.successSaveReceipt = true
    }
    func setRollbackDataCreateReceipt(receiptID: String) {
        self.receiptID = receiptID
        
        self.successCreateReceipt = true
    }
    
    
    
    
    // MARK: - 데이터 초기화
    func clearRollbackData() {
        self.versionID = nil
        self.receiptID = nil
        self.payerID = nil
        self.usersIDArray = nil
        self.savedPaybackDict = nil
        self.savedCumulativeMoneyDict = nil
        
        self.successCreateReceipt = false
        self.successSaveReceipt = false
        self.successCumulativeMoney = false
        self.successPayback = false
    }
    
    
    
    // MARK: - 롤백 시작
    // 롤백을 시작하는 메서드
    // 특정 메서드가 롤백에 실패하더라도 모든 메서드가 실행 됨.
    func startRollback() async throws {
        var rollbackErrors: [Error] = []

        
        // 롤백 작업과 그에 대응하는 식별 정보를 튜플 배열로 준비
        let rollbackOperations = [
            (self.successPayback,           self.rollbackPaybackData),
            (self.successCumulativeMoney,   self.rollbackCumulativeMoneyData),
            (self.successSaveReceipt,       self.rollbackSaveUsersReceiptData),
            (self.successCreateReceipt,     self.rollbackCreateReceiptData)
        ]
        
        // 롤백 작업을 순차적으로 실행
        for (condition, operation) in rollbackOperations {
            if condition {
                do {
                    try await self.executeRollbackOperation(operation)
                } catch {
                    rollbackErrors.append(error)
                }
            }
        }

        // 롤백 과정에서 발생한 모든 에러를 처리합니다.
        if !rollbackErrors.isEmpty {
            throw ErrorEnum.readError
        }
    }

    // 롤백 작업 실행과 에러 처리를 담당하는 함수
    private func executeRollbackOperation(_ operation: () async throws -> Void) async throws {
        try await operation()
    }
    
    
    
    // MARK: - 롤백 실패 시 로그 저장
    private func logRollbackFailure(
        rollbackType: RollBackReceiptEnum,
        errorData: RollbackResult,
        error: Error)
    {
        // 유저의 아이디 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 롤백 실패 정보를 데이터베이스에 저장하는 로직
        // 예: 실패한 사용자 ID, 에러 메시지, 롤백 시도 시간 등
        let failureInfo = self.returnErrorLog(
            rollbackType: rollbackType,
            errorData: errorData,
            error: error)
        
        // 현재 시간을 String타입으로 가져오기
        let currentTime = Date().returnErrorLogType()
        
        // 데이터베이스에 저장
        Rollback_ERROR_REF
            .child(uid)
            .child(currentTime)
            .setValue(failureInfo)
    }
    
    
    
    
    // MARK: - 저장할 로그 리턴
    func returnErrorLog(rollbackType: RollBackReceiptEnum,
                        errorData: RollbackResult,
                        error: Error) -> [String: Any] {
        
        var errorDict: [String: Any] = [
             "type": rollbackType.description,
             "versionID": self.versionID ?? "",
             "error": error.localizedDescription,
             "originalData": errorData.originalData,
             "successData": errorData.successData,
             "failedData": errorData.failedData
         ]
        
        switch rollbackType {
        case .payback:
            errorDict["savedPaybackDict"] = self.savedPaybackDict
            errorDict["payerID"] = self.payerID
            
        case .cumulativeMoney:
            errorDict["savedCumulativeMoneyDict"] = self.savedCumulativeMoneyDict
            
        case .createReceipt:
            errorDict["usersIDArray"] = self.usersIDArray
            
            fallthrough
        case .saveReceipt:
            errorDict["receiptID"] = self.receiptID
        }
        let dict = errorDict.compactMapValues{ $0 }
        
        return dict
    }
}










// MARK: - 롤백 함수

extension RollbackDataManager {
    
    // MARK: - 페이백 롤백
    private func rollbackPaybackData() async throws {
        var rollbackResult = RollbackResult(
            success: true,
            originalData: savedPaybackDict ?? [:],
            successData: [:],
            failedData: [:])

        guard let versionID = self.versionID, 
                let payerID = self.payerID,
              let savedPaybackDict = self.savedPaybackDict
        else {
            rollbackResult.success = false
            
            self.logRollbackFailure(
                rollbackType: .payback,
                errorData: rollbackResult,
                error: ErrorEnum.readError)
            throw ErrorEnum.readError
        }

        for (userID, amountToSubtract) in savedPaybackDict {
            let path = PAYBACK_REF
                .child(versionID)
                .child(payerID)
                .child(userID)
            
            let transactionResult = await performPaybackTransaction(
                path: path,
                amountToSubtract: amountToSubtract)

            switch transactionResult {
            case .success(let newAmount):
                rollbackResult.successData[userID] = newAmount
                
            case .failure:
                rollbackResult.failedData[userID] = amountToSubtract
                rollbackResult.success = false
            }
        }

        if !rollbackResult.success {
            // 롤백 실패 정보 로깅
            self.logRollbackFailure(
                rollbackType: .payback,
                errorData: rollbackResult,
                error: ErrorEnum.readError)
            throw ErrorEnum.readError
        }
    }
    
    
    
    // MARK: - 페이백 트랜잭션
    private func performPaybackTransaction(
        path: DatabaseReference, 
        amountToSubtract: Int) async
    -> Result<Int, Error> {
        await withCheckedContinuation { continuation in
            path.runTransactionBlock { (currentData: MutableData) -> TransactionResult in
                // currentData.value를 Int로 안전하게 캐스팅
                guard let currentValue = currentData.value as? Int else {
                    // 캐스팅에 실패한 경우, 적절한 에러 반환
                    continuation.resume(returning: .failure(ErrorEnum.readError)) // 실제 에러 타입에 맞게 수정
                    return TransactionResult.abort()
                }

                let newValue = currentValue - amountToSubtract
                // newValue가 유효한지 확인
                if newValue < 0 {
                    // newValue가 유효하지 않은 경우, 적절한 에러 반환
                    continuation.resume(returning: .failure(ErrorEnum.readError)) // 실제 에러 타입에 맞게 수정
                    return TransactionResult.abort()
                }

                // 업데이트된 값을 currentData에 할당
                currentData.value = newValue
                // 업데이트 성공을 반환
                continuation.resume(returning: .success(newValue))
                return TransactionResult.success(withValue: currentData)
            }
        }
    }
    
    
    
    
    
    // MARK: - 누적금액 롤백
    private func rollbackCumulativeMoneyData() async throws {
        var rollbackResult = RollbackResult(
            success: true,
            originalData: savedCumulativeMoneyDict ?? [:],
            successData: [:],
            failedData: [:])

        guard let versionID = self.versionID, let savedCumulativeMoneyDict = self.savedCumulativeMoneyDict else {
            rollbackResult.success = false
            self.logRollbackFailure(
                rollbackType: .cumulativeMoney,
                errorData: rollbackResult,
                error: ErrorEnum.readError)
            throw ErrorEnum.readError
        }

        for (userId, amountToSubtract) in savedCumulativeMoneyDict {
            let path = Cumulative_AMOUNT_REF.child(versionID).child(userId)
            let transactionResult = await performCumulativeMoneyTransaction(path: path, amountToSubtract: amountToSubtract)

            switch transactionResult {
            case .success(let newAmount):
                rollbackResult.successData[userId] = newAmount
                
            case .failure:
                rollbackResult.failedData[userId] = amountToSubtract
                rollbackResult.success = false
            }
        }

        if !rollbackResult.success {
            // 롤백 실패 정보 로깅
            self.logRollbackFailure(
                rollbackType: .cumulativeMoney,
                errorData: rollbackResult,
                error: ErrorEnum.readError)
            throw ErrorEnum.readError
        }
    }
    
    
    
    // MARK: - 누적금액 트랜잭션
    private func performCumulativeMoneyTransaction(
        path: DatabaseReference,
        amountToSubtract: Int) async
    -> Result<Int, Error> {
        await withCheckedContinuation { continuation in
            path.runTransactionBlock { (currentData: MutableData) -> TransactionResult in
                // currentData.value가 Int로 캐스팅되지 않거나 nil인 경우 에러 처리
                guard let currentValue = currentData.value as? Int else {
                    continuation.resume(returning: .failure(ErrorEnum.readError)) // 적절한 에러 타입으로 교체해주세요
                    return TransactionResult.abort()
                }

                let newValue = currentValue - amountToSubtract
                // 새로운 값이 유효한지 확인
                if newValue < 0 {
                    continuation.resume(returning: .failure(ErrorEnum.readError)) // 적절한 에러 타입으로 교체해주세요
                    return TransactionResult.abort()
                }

                // 새로운 값으로 업데이트
                currentData.value = newValue
                continuation.resume(returning: .success(newValue))
                return TransactionResult.success(withValue: currentData)
            }
        }
    }
    
    
    
    
    
    // MARK: - 유저 영수증 롤백
    private func rollbackSaveUsersReceiptData() async throws {
        try await performGenericRollbackAction(
            with: .saveReceipt, 
            receiptID: self.receiptID,
            usersIDArray: self.usersIDArray)
    }
    
    
    
    // MARK: - 영수증 생성 롤백
    private func rollbackCreateReceiptData() async throws {
        try await performGenericRollbackAction(
            with: .createReceipt,
            receiptID: self.receiptID)
    }
    
    
    
    // MARK: - 범용 롤백 작업 실행 함수
    // 범용 롤백 작업 실행 함수
    private func performGenericRollbackAction(
        with type: RollBackReceiptEnum,
        receiptID: String?,
        usersIDArray: [String]? = nil) async throws
    {
        
        guard let receiptID = self.receiptID,
              let versionID = self.versionID
        else {
            throw ErrorEnum.readError // 적절한 에러 처리
        }

        var rollbackResult = RollbackResult(
            success: true,
            originalData: [:],
            successData: [:],
            failedData: [:])
        
        // SaveReceipt
        if let usersIDArray = self.usersIDArray {
            for userID in usersIDArray {
                let path = USER_RECEIPTS_REF
                    .child(userID)
                    .child(receiptID)
                
                await performRollbackAction(path: path) { success in
                    if !success {
                        rollbackResult.failedData[userID] = false
                        rollbackResult.success = false
                    } else {
                        rollbackResult.successData[userID] = true
                    }
                }
            }
            
            
            
        // CreateReceipt
        } else {
            let path = RECEIPT_REF
                .child(versionID)
                .child(receiptID)
            
            await performRollbackAction(path: path) { success in
                if !success {
                    rollbackResult.failedData["receiptID"] = false
                    rollbackResult.success = false
                    
                } else {
                    rollbackResult.successData["receiptID"] = true
                }
            }
        }

        if !rollbackResult.success {
            self.logRollbackFailure(
                rollbackType: type,
                errorData: rollbackResult, 
                error: ErrorEnum.readError)
            
            throw ErrorEnum.readError
        }
    }
    
    
    
    // MARK: - 공통 롤백
    // 롤백 공통 함수를 사용하여 중복을 줄입니다.
    private func performRollbackAction(
        path: DatabaseReference,
        completion: @escaping (Bool) -> Void) async
    {
        do {
            try await path.removeValue()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
