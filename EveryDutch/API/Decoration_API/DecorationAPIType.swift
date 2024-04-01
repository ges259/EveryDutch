//
//  DecorationAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/30/24.
//

import Foundation

protocol DecorationAPIType {}

extension DecorationAPIType {
    
    
    // MARK: - 데코레이션 가져오기
    func fetchDecoration(
        dataRequiredWhenInEidtMode: String?
    ) async throws -> Decoration? {
        
        guard let dataRequiredWhenInEidtMode = dataRequiredWhenInEidtMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Decoration?, Error>) in
            
            CARD_DATA_REF
                .child(dataRequiredWhenInEidtMode)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    guard snapshot.exists() else {
                        // 스냅샷에 데이터가 존재하지 않는 경우, 기본 Decoration 객체 반환
                        continuation.resume(returning: nil)
                        return
                    }
                    guard let value = snapshot.value as? [String: Any] else {
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    let decoration = Decoration(dictionary: value)
                    continuation.resume(returning: decoration)
                }
        }
    }
    
    
    // MARK: - 데코레이션 업데이트
    func updateDecoration(
        at ref: String?,
        with dict: [String: Any?]
    ) async throws {
        
        guard let ref = ref else { throw ErrorEnum.readError }
        let decorationDict = dict.compactMapValues { $0 }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            CARD_DATA_REF
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
