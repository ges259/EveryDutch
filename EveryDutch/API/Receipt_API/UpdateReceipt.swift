//
//  UpdateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabaseInternal

// Update
// type 변경 ----- (Receipt)
// payment_details[done: Bool] 변경 ----- (Receipt)

extension ReceiptAPI {
    
    // MARK: - PaymentDetail 업데이트
    func updatePaymentDetail(
        versionID: String,
        receiptID: String,
        paymentDetailsDict: [String : [String : Any]]
    ) async throws {
        let path = RECEIPT_REF
            .child(versionID)
            .child(receiptID)
            .child(DatabaseConstants.payment_details)
        
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<(Void), Error>) in
            path.updateChildValues(paymentDetailsDict) { error, _ in
                if let _ = error {
                    continuation.resume(throwing: ErrorEnum.unknownError)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    
    
    // MARK: - 누적 금액 업데이트
    func updateCumulativeMoney(
        versionID: String,
        moneyDict: [String: Int]
    ) async throws {
        let reference = CUMULATIVE_AMOUNT_REF.child(versionID)
        try await self.performTransactionUpdate(
            forRef: reference,
            withDict: moneyDict)
    }
    
    // MARK: - 페이백 업데이트
    func updatePayback(
        versionID: String,
        payerID: String,
        moneyDict: [String: Int]
    ) async throws {
        var paybackDict = moneyDict
        paybackDict.removeValue(forKey: payerID)
        let reference = PAYBACK_REF.child(versionID).child(payerID)
        try await self.performTransactionUpdate(
            forRef: reference,
            withDict: paybackDict)
    }
    /// 트랜잭션 업데이트를 위한 공통 함수
    private func performTransactionUpdate(
        forRef reference: DatabaseReference,
        withDict moneyDict: [String: Int]
    ) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for (userID, amount) in moneyDict {
                group.addTask {
                    let userRef = reference.child(userID)
                    try await self.updateAmount(
                        forUserRef: userRef,
                        amount: amount)
                }
            }
            try await group.waitForAll()
        }
    }
    private func updateAmount(
        forUserRef userRef: DatabaseReference,
        amount: Int
    ) async throws {
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
    
    
    
    // MARK: - 타입 업데이트
    // 새로운 함수: 영수증 타입 업데이트
    func updateReceiptType(
        versionID: String,
        receiptID: String,
        newType: Int
    ) async throws {
        let path = RECEIPT_REF
            .child(versionID)
            .child(receiptID)
            .child(DatabaseConstants.type)
        
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            path.setValue(newType) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
