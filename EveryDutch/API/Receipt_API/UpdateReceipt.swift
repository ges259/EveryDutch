//
//  UpdateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

// Update
    // type 변경 ----- (Receipt)
// payment_details[done: Bool] 변경 ----- (Receipt)

extension ReceiptAPI {
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
}
