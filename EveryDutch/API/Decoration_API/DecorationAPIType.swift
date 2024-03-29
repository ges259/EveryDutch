//
//  DecorationAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/30/24.
//

import Foundation

protocol DecorationAPIType {}

extension DecorationAPIType {
    func fetchDecoration(dataRequiredWhenInEidtMode: String?) async throws -> Decoration {
        guard let dataRequiredWhenInEidtMode = dataRequiredWhenInEidtMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            
            CARD_DATA_REF
                .child(dataRequiredWhenInEidtMode)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    guard let value = snapshot.value as? [String: Any] else {
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    
                    let decoration = Decoration(dictionary: value)
                    continuation.resume(returning: decoration)
                }
        }
    }
}
