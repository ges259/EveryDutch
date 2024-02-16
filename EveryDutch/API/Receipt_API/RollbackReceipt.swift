//
//  RollbackReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 2/16/24.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

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
        errorData: [String: Any],
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
                        errorData: [String: Any],
                        error: Error) -> [String: Any] {
        
        var errorDict: [String: Any?] = ["type" : rollbackType.description,
                                         "versionID" : self.versionID,
                                         "error" : error.localizedDescription,
                                         "errorData" : errorData]
        
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
        // 필수 프로퍼티가 존재하는지 확인합니다.
        // versionID, payerID, 및 usersMoneyDict가 모두 필요합니다.
        guard let versionID = self.versionID,
              let payerID = self.payerID,
              let savedPaybackDict = self.savedPaybackDict else {
            
            // 하나라도 없다면, 롤백을 진행할 수 없으므로 readError를 던집니다.
            self.logRollbackFailure(
                rollbackType: .payback,
                errorData: self.savedPaybackDict ?? [:],
                error: ErrorEnum.readError)
            throw ErrorEnum.readError
        }
        
        
        
        
        // usersMoneyDict에 저장된 모든 사용자에 대해 반복합니다.
        // userID는 사용자 식별자이고, amountToSubtract는 감소시킬 금액입니다.
        for (userID, amountToSubtract) in savedPaybackDict {
            // Firebase Realtime Database의 경로를 구성합니다.
            // versionID, payerID, 그리고 userID를 포함하는 경로입니다.
            let path = PAYBACK_REF
                .child(versionID)
                .child(payerID)
                .child(userID)
            
            // 비동기 작업을 위한 withCheckedThrowingContinuation을 사용합니다.
            // 이는 비동기 작업의 결과를 처리하기 위한 방식입니다.
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                // Firebase의 트랜잭션 블록을 시작합니다.
                // currentData는 현재 데이터베이스의 데이터 상태를 나타냅니다.
                path.runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        // currentData의 값을 Int로 변환을 시도합니다.
                        // 변환에 실패할 경우 nil이 될 것이므로, 0을 기본값으로 사용합니다.
                        guard let currentAmount = currentData.value as? Int else {
                            // Int로의 변환이 실패하면, 롤백 과정에 문제가 있음을 의미하므로,
                            self.logRollbackFailure(
                                rollbackType: .cumulativeMoney,
                                errorData: savedPaybackDict,
                                error: ErrorEnum.readError)
                            
                            // 에러를 던지고 트랜잭션을 중단합니다.
                            continuation.resume(throwing: ErrorEnum.readError)
                            return TransactionResult.abort()
                        }
                        
                        // currentAmount에서 amountToSubtract를 빼서 새 금액을 계산합니다.
                        let newAmount = currentAmount - amountToSubtract
                        
                        // 계산된 새 금액이 0 미만이면, 이는 잘못된 상태를 의미하므로,
                        // 롤백 과정에 문제가 있다고 판단하고 에러를 던집니다.
                        if newAmount < 0 {
                            // Int로의 변환이 실패하면, 롤백 과정에 문제가 있음을 의미하므로,
                            self.logRollbackFailure(
                                rollbackType: .cumulativeMoney,
                                errorData: savedPaybackDict,
                                error: ErrorEnum.readError)
                            continuation.resume(throwing: ErrorEnum.readError)
                            return TransactionResult.abort()
                        }
                        
                        // 계산된 새 금액이 유효하면, currentData의 값을 업데이트합니다.
                        currentData.value = newAmount
                        // 트랜잭션 성공 결과와 함께 업데이트된 값을 반환합니다.
                        return TransactionResult.success(withValue: currentData)
                        
                    }, andCompletionBlock: { error, _, _ in
                        // 트랜잭션이 완료된 후 실행됩니다.
                        if let error = error {
                            // Int로의 변환이 실패하면, 롤백 과정에 문제가 있음을 의미하므로,
                            self.logRollbackFailure(
                                rollbackType: .cumulativeMoney,
                                errorData: savedPaybackDict,
                                error: ErrorEnum.readError)
                            // 에러가 발생했다면, 에러를 던집니다.
                            continuation.resume(throwing: ErrorEnum.readError)
                        } else {
                            // 에러가 없다면, 작업이 성공적으로 완료되었음을 의미합니다.
                            continuation.resume(returning: ())
                        }
                    })
            }
        }
    }
    
    // MARK: - 누적금액 롤백
    private func rollbackCumulativeMoneyData() async throws {
        // 필요한 프로퍼티가 존재하는지 확인
        guard let versionID = self.versionID,
              let savedCumulativeMoneyDict = self.savedCumulativeMoneyDict else {
            // Int로의 변환이 실패하면, 롤백 과정에 문제가 있음을 의미하므로,
            self.logRollbackFailure(
                rollbackType: .cumulativeMoney,
                errorData: savedCumulativeMoneyDict ?? [:],
                error: ErrorEnum.readError)
            // 필요한 값이 없으면 에러를 던집니다.
            throw ErrorEnum.readError
        }

        // 각 사용자의 누적 금액을 감소시키는 작업 실행
        for (userId, amountToSubtract) in savedCumulativeMoneyDict {
            let path = Cumulative_AMOUNT_REF
                .child(versionID)
                .child(userId)
            
            // Firebase 트랜잭션을 이용하여 데이터를 안전하게 업데이트
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                path.runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        guard let currentAmount = currentData.value as? Int else {
                            // currentData.value가 Int로 캐스팅되지 않으면 에러를 던집니다.
                            self.logRollbackFailure(
                                rollbackType: .cumulativeMoney,
                                errorData: savedCumulativeMoneyDict,
                                error: ErrorEnum.readError)
                            continuation.resume(throwing: ErrorEnum.readError)
                            return TransactionResult.abort()
                        }

                        let newAmount = currentAmount - amountToSubtract

                        // 계산된 새 금액이 0 미만이면, 에러를 던집니다.
                        if newAmount < 0 {
                            continuation.resume(throwing: ErrorEnum.readError)
                            self.logRollbackFailure(
                                rollbackType: .cumulativeMoney,
                                errorData: savedCumulativeMoneyDict,
                                error: ErrorEnum.readError)
                            return TransactionResult.abort()
                        }

                        // 계산된 새 금액이 유효하면, currentData의 값을 업데이트합니다.
                        currentData.value = newAmount
                        return TransactionResult.success(withValue: currentData)
                        
                    }, andCompletionBlock: { error, _, _ in
                        if let error = error {
                            self.logRollbackFailure(
                                rollbackType: .cumulativeMoney,
                                errorData: savedCumulativeMoneyDict,
                                error: ErrorEnum.readError)
                            // 에러 발생 시, 에러를 던집니다.
                            continuation.resume(throwing: ErrorEnum.readError)
                        } else {
                            // 성공적으로 완료되면, 계속 진행합니다.
                            continuation.resume(returning: ())
                        }
                    })
            }
        }
    }
    
    
    

    // MARK: - 유저 영수증 롤백
    private func rollbackSaveUsersReceiptData() async throws {
        // 필요한 프로퍼티가 존재하는지 확인
        guard let usersIDArray = self.usersIDArray,
              let receiptID = self.receiptID
        else {
            self.logRollbackFailure(
                rollbackType: .saveReceipt,
                errorData: [:],
                error: ErrorEnum.readError)
            // 필요한 값이 없으면 에러를 던집니다.
            throw ErrorEnum.readError
        }
        
        for userID in usersIDArray {
            let path = USER_RECEIPTS_REF
                .child(userID)
                .child(receiptID)
            
            
            do {
                try await path.removeValue()
                
            } catch {
                self.logRollbackFailure(
                    rollbackType: .saveReceipt,
                    errorData: ["userID": userID],
                    error: error)
                throw error
            }
        }
    }

    // MARK: - 영수증 생성 롤백
    private func rollbackCreateReceiptData() async throws {
        // 필요한 프로퍼티가 존재하는지 확인
        guard let versionID = self.versionID,
              let receiptID = self.receiptID
        else {
            self.logRollbackFailure(
                rollbackType: .saveReceipt,
                errorData: [:],
                error: ErrorEnum.readError)
            // 필요한 값이 없으면 에러를 던집니다.
            throw ErrorEnum.readError
        }
        
        let path = RECEIPT_REF
            .child(versionID)
            .child(receiptID)
        
        
        
        // Firebase에서 해당 영수증 데이터를 삭제
        do {
            try await path.removeValue()
        } catch {
            self.logRollbackFailure(
                rollbackType: .createReceipt,
                errorData: [:],
                error: error)
            throw error
        }
        
        
    }
}
