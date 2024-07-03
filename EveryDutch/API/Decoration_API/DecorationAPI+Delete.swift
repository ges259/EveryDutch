//
//  DecorationAPI+Delete.swift
//  EveryDutch
//
//  Created by 계은성 on 7/3/24.
//

import Foundation

extension DecorationAPI {
    func deleteDecoration(
        with dataRequiredWhenInEditMode: String?
    ) async throws {
        
        guard let decoID = dataRequiredWhenInEditMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            CARD_DECORATION_REF
                .child(decoID)
                .removeValue { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
