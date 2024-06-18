//
//  DecorationAPI+Update.swift
//  EveryDutch
//
//  Created by 계은성 on 6/2/24.
//

import Foundation

extension DecorationAPI {
    
    // MARK: - 데코레이션 업데이트
    func updateDecoration(
        at ref: String?,
        with dict: [String: Any?]
    ) async throws {
        
        guard let ref = ref else { throw ErrorEnum.readError }
        let decorationDict = dict.compactMapValues { $0 }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            CARD_DECORATION_REF
                .child(ref)
                .updateChildValues(decorationDict) { error, _ in
                    if let _ = error {
                        continuation.resume(throwing: ErrorEnum.unknownError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
        }
    }
}
