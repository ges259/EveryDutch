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

class ReceiptAPI: ReceiptAPIProtocol {
    static let shared: ReceiptAPIProtocol = ReceiptAPI()
    private init() {}
    
    private let maxRetryCount = 3 // 최대 재시도 횟수 설정
    private let retryDelay = 2.0 // 재시도 간 지연 시간(초)
}

extension ReceiptAPI {
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
    
    // MARK: - 영수증 만들기
    func createReceipt(
        versionID: String,
        dictionary: [String: Any?],
        retryCount: Int = 0,
        completion: @escaping Typealias.CreateReceiptCompletion)
    {
            
        let dict = dictionary.compactMapValues{ $0 }
        
        RECEIPT_REF
            .child(versionID)
            .childByAutoId()
            .setValue(dict) { error, ref in
                
                if let _ = error {
                    
                    if retryCount < self.maxRetryCount {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                            self.createReceipt(versionID: versionID,
                                               dictionary: dictionary,
                                               retryCount: retryCount + 1, 
                                               completion: completion)
                            
                        }
                        
                    } else {
                        completion(.failure(.readError))
                    }
                    
                } else {
                    print("Data saved successfully!")
                    
                    if let receiptKey = ref.key {
                        completion(.success(receiptKey))
                        return
                        
                    } else {
                        
                        
                    }
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
        
        for userID in users {
            
            saveGroup.enter()
            
            USER_RECEIPTS_REF
                .child(userID)
                .updateChildValues([receiptID: true]) { error, _ in
                    
                    if let error = error {
                        print("Error saving user receipt mapping: \(error.localizedDescription)")
                        if retryCount < self.maxRetryCount {
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                                self.saveReceiptForUsers(
                                    receiptID: receiptID,
                                    users: users,
                                    retryCount: retryCount + 1,
                                    completion: completion)
                                return
                            }
                        }
                    }
                    saveGroup.leave()
                }
        }
        
        saveGroup.notify(queue: .main) {
            print("All user receipt mappings saved successfully!")
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
        // 초기 시도에서 모든 사용자를 재시도 딕셔너리에 추가
        var retryUsersMoneyDict = usersMoneyDict

        let group = DispatchGroup()
        
        for (userId, amountToAdd) in usersMoneyDict {
            group.enter()
            
            Cumulative_AMOUNT_REF
                .child(versionID)
                .child(userId)
                .runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        var value = currentData.value as? Int ?? 0
                        value += amountToAdd
                        currentData.value = value
                        
                        return TransactionResult.success(withValue: currentData)
                    }) { error, _, _ in
                        if error == nil {
                            // 에러가 없다면 성공적으로 저장됐으므로 재시도 딕셔너리에서 해당 사용자 삭제
                            retryUsersMoneyDict.removeValue(forKey: userId)
                        }
                        group.leave()
                    }
        }
        
        group.notify(queue: .main) {
            if !retryUsersMoneyDict.isEmpty 
                && retryCount < self.maxRetryCount {
                // 실패한 작업에 대해 재시도
                DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                    self.updateCumulativeMoney(
                        versionID: versionID,
                        usersMoneyDict: retryUsersMoneyDict,
                        retryCount: retryCount + 1,
                        completion: completion
                    )
                }
            } else if !retryUsersMoneyDict.isEmpty {
                // 최대 재시도 횟수에 도달했으나 실패한 작업이 있는 경우
                completion(.failure(.readError))
            } else {
                // 모든 작업이 성공적으로 완료됨
                completion(.success(()))
            }
        }
    }
    
    
    
    // MARK: - 페이백 업데이트
    func updatePayback(
        versionID: String,
        payerID: String,
        usersMoneyDict: [String: Int],
        retryCount: Int = 0,
        completion: @escaping Typealias.baseCompletion)
    {
        // 초기 시도에서 모든 사용자를 재시도 딕셔너리에 추가
        var retryUsersMoneyDict = usersMoneyDict
        let group = DispatchGroup()

        for (userID, amount) in usersMoneyDict {
            group.enter()
            
            PAYBACK_REF
                .child(versionID)
                .child(payerID)
                .child(userID)
                .runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        var currentAmount = currentData.value as? Int ?? 0
                        currentAmount += amount
                        currentData.value = currentAmount
                        return TransactionResult.success(withValue: currentData)
                    }) { error, _, _ in
                        if let error = error {
                            print("Error updating payback for user \(userID): \(error.localizedDescription)")
                            // 에러 발생 시에만 딕셔너리에 남겨둠
                        } else {
                            // 작업 성공 시 재시도 딕셔너리에서 해당 사용자 제거
                            retryUsersMoneyDict.removeValue(forKey: userID)
                        }
                        group.leave()
                    }
        }
        
        group.notify(queue: .main) {
            if !retryUsersMoneyDict.isEmpty 
                && retryCount < self.maxRetryCount {
                // 실패한 작업에 대해 재시도
                DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                    self.updatePayback(
                        versionID: versionID,
                        payerID: payerID,
                        usersMoneyDict: retryUsersMoneyDict,
                        retryCount: retryCount + 1,
                        completion: completion
                    )
                }
            } else if !retryUsersMoneyDict.isEmpty {
                // 최대 재시도 횟수에 도달했으나 여전히 실패한 작업이 있는 경우
                completion(.failure(.readError))
            } else {
                // 모든 작업이 성공적으로 완료됨
                completion(.success(()))
            }
        }
    }
}























enum RollBackReceipt {
    case payback
    case cumulativeMoney
    case usersReceipt
    case saveReceipt
}

// MARK: - 롤백 함수

extension ReceiptAPI {
    
    // MARK: - 롤백
    private func rollBackReceipt(rollback: RollBackReceipt) {
        switch rollback {
        case .payback:
            
            fallthrough
        case .cumulativeMoney:
            
            fallthrough
        case .usersReceipt:
            
            fallthrough
        case .saveReceipt:
            
            break
        }
    }
    
    // MARK: - 영수증 생성 롤백
    private func rollbackSaveReceiptData(
        versionID: String,
        receiptID: String,
        completion: @escaping (Bool) -> Void)
    {
        RECEIPT_REF
            .child(versionID)
            .child(receiptID)
            .removeValue { error, _ in
                
            if let error = error {
                print("영수증 저장 데이터 롤백 실패: \(error.localizedDescription)")
                completion(false)
                
            } else {
                print("영수증 저장 데이터 롤백 성공")
                completion(true)
            }
        }
    }

    // MARK: - 유저 영수증 롤백
    private func rollbackUsersReceiptData(
        users: [String],
        receiptID: String,
        completion: @escaping (Bool) -> Void)
    {
        let rollbackGroup = DispatchGroup()
        var rollbackSuccess = true

        for userID in users {
            rollbackGroup.enter()
            USER_RECEIPTS_REF
                .child(userID)
                .child(receiptID)
                .removeValue { error, _ in
                    
                if let error = error {
                    print("사용자 영수증 데이터 롤백 실패: \(userID), 오류: \(error.localizedDescription)")
                    rollbackSuccess = false
                } else {
                    print("사용자 영수증 데이터 롤백 성공: \(userID)")
                }
                rollbackGroup.leave()
            }
        }

        rollbackGroup.notify(queue: .main) {
            completion(rollbackSuccess)
        }
    }

    // MARK: - 누적금액 롤백
    private func rollbackCumulativeMoneyData(
        versionID: String,
        usersMoneyDict: [String: Int],
        completion: @escaping (Bool) -> Void)
    {
        let rollbackGroup = DispatchGroup()
        var rollbackSuccess = true
        
        for (userId, amountToSubtract) in usersMoneyDict {
            rollbackGroup.enter()
            Cumulative_AMOUNT_REF
                .child(versionID)
                .child(userId)
                .runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        
                        var value = currentData.value as? Int ?? 0
                        value -= amountToSubtract
                        currentData.value = value
                        return TransactionResult.success(withValue: currentData)
                    }) { error, _, _ in
                        if let error = error {
                            print("누적 금액 데이터 롤백 실패: \(userId), 오류: \(error.localizedDescription)")
                            rollbackSuccess = false
                        } else {
                            print("누적 금액 데이터 롤백 성공: \(userId)")
                        }
                        rollbackGroup.leave()
                    }
        }
        
        rollbackGroup.notify(queue: .main) {
            completion(rollbackSuccess)
        }
    }
    
    // MARK: - 페이백 롤백
    private func rollbackPaybackData(
        versionID: String, 
        payerID: String,
        usersMoneyDict: [String: Int],
        completion: @escaping (Bool) -> Void)
    {
        let rollbackGroup = DispatchGroup()
        var rollbackSuccess = true
        
        for (userID, amountToSubtract) in usersMoneyDict {
            rollbackGroup.enter()
            PAYBACK_REF
                .child(versionID)
                .child(payerID)
                .child(userID)
                .runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        
                        var currentAmount = currentData.value as? Int ?? 0
                        currentAmount -= amountToSubtract
                        currentData.value = currentAmount >= 0 ? currentAmount : 0
                        return TransactionResult.success(withValue: currentData)
                        
                    }) { error, committed, _ in
                        if let error = error {
                            print("페이백 데이터 롤백 실패: \(userID), 오류: \(error.localizedDescription)")
                            rollbackSuccess = false
                        } else {
                            print("페이백 데이터 롤백 성공: \(userID)")
                        }
                        rollbackGroup.leave()
                    }
        }
        
        rollbackGroup.notify(queue: .main) {
            completion(rollbackSuccess)
        }
    }
}






















class RollbackDataManager {
    static let shared = RollbackDataManager()
    private init() {}
    
    
    
    
    
    private var versionID: String?
    private var receiptID: String?
    private var usersIDArray: [String]?
    private var payerID: String?
    private var savedCumulativeMoneyDict: [String: Int]?
    private var savedPaybackDict: [String: Int]?
    
    
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
    
    // 롤백을 시작하는 메서드
    func startRollback() async throws {
    }
}



extension RollbackDataManager {
    
    // MARK: - 페이백 롤백
    private func rollbackPaybackData(completion: @escaping (Bool) -> Void) {
        
        guard self.successPayback,
              let versionID = self.versionID,
              let payerID = self.payerID,
              let usersMoneyDict = self.savedPaybackDict else {
            print("롤백 데이터 누락")
            completion(false)
            return
        }
        
        
        let rollbackGroup = DispatchGroup()
        var rollbackSuccess = true
        
        for (userID, amountToSubtract) in usersMoneyDict {
            rollbackGroup.enter()
            PAYBACK_REF
                .child(versionID)
                .child(payerID)
                .child(userID)
                .runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        
                        var currentAmount = currentData.value as? Int ?? 0
                        currentAmount -= amountToSubtract
                        currentData.value = currentAmount >= 0 ? currentAmount : 0
                        return TransactionResult.success(withValue: currentData)
                        
                    }) { error, committed, _ in
                        if let error = error {
                            print("페이백 데이터 롤백 실패: \(userID), 오류: \(error.localizedDescription)")
                            rollbackSuccess = false
                        } else {
                            print("페이백 데이터 롤백 성공: \(userID)")
                        }
                        rollbackGroup.leave()
                    }
        }
        
        rollbackGroup.notify(queue: .main) {
            completion(rollbackSuccess)
        }
    }
    
    // MARK: - 누적금액 롤백
    private func rollbackCumulativeMoneyData(completion: @escaping (Bool) -> Void) {
        
        guard self.successCumulativeMoney,
              let versionID = self.versionID,
              let usersMoneyDict = self.savedCumulativeMoneyDict
        else {
            print("롤백 데이터 누락")
            completion(false)
            return
        }
        
        let rollbackGroup = DispatchGroup()
        var rollbackSuccess = true
        
        for (userId, amountToSubtract) in usersMoneyDict {
            rollbackGroup.enter()
            Cumulative_AMOUNT_REF
                .child(versionID)
                .child(userId)
                .runTransactionBlock(
                    { (currentData: MutableData) -> TransactionResult in
                        
                        var value = currentData.value as? Int ?? 0
                        value -= amountToSubtract
                        currentData.value = value
                        return TransactionResult.success(withValue: currentData)
                    }) { error, _, _ in
                        if let error = error {
                            print("누적 금액 데이터 롤백 실패: \(userId), 오류: \(error.localizedDescription)")
                            rollbackSuccess = false
                        } else {
                            print("누적 금액 데이터 롤백 성공: \(userId)")
                        }
                        rollbackGroup.leave()
                    }
        }
        
        rollbackGroup.notify(queue: .main) {
            completion(rollbackSuccess)
        }
    }
    
    // MARK: - 유저 영수증 롤백
    private func rollbackUsersReceiptData(completion: @escaping (Bool) -> Void) {
        
        guard self.successSaveReceipt,
              let users = self.usersIDArray,
              let receiptID = self.receiptID else {
            print("롤백 데이터 누락")
            completion(false)
            return
        }
        
        let rollbackGroup = DispatchGroup()
        var rollbackSuccess = true

        for userID in users {
            rollbackGroup.enter()
            USER_RECEIPTS_REF
                .child(userID)
                .child(receiptID)
                .removeValue { error, _ in
                    
                if let error = error {
                    print("사용자 영수증 데이터 롤백 실패: \(userID), 오류: \(error.localizedDescription)")
                    rollbackSuccess = false
                } else {
                    print("사용자 영수증 데이터 롤백 성공: \(userID)")
                }
                rollbackGroup.leave()
            }
        }

        rollbackGroup.notify(queue: .main) {
            completion(rollbackSuccess)
        }
    }
    
    // MARK: - 영수증 생성 롤백
    private func rollbackSaveReceiptData(completion: @escaping (Bool) -> Void) {
        
        guard self.successCreateReceipt,
              let versionID = self.versionID,
              let receiptID = self.receiptID else {
            print("롤백 데이터 누락")
            completion(false)
            return
        }
        
        RECEIPT_REF
            .child(versionID)
            .child(receiptID)
            .removeValue { error, _ in
                
            if let error = error {
                print("영수증 저장 데이터 롤백 실패: \(error.localizedDescription)")
                completion(false)
                
            } else {
                print("영수증 저장 데이터 롤백 성공")
                completion(true)
            }
        }
    }
}
