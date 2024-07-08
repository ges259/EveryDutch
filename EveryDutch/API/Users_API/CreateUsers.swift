//
//  CreateUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseAuth

struct UserAPI: UserAPIProtocol {
    static let shared: UserAPIProtocol = UserAPI()
    private init() {}
    

    func createData(dict: [String: Any]) async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw ErrorEnum.readError
        }
        
        try await self.updateUserData(userID: uid, dict: dict)
        
        return uid
    }
    
    func updateData(IdRef: String, dict: [String: Any]) async throws {
        try await self.updateUserData(userID: IdRef, dict: dict)
    }
    
    private func updateUserData(
        userID: String,
        dict: [String: Any]
    ) async throws {

        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            USER_REF
                .child(userID)
                .updateChildValues(dict) { error, _ in
                    if let _ = error {
                        continuation.resume(throwing: ErrorEnum.unknownError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
        }
    }
    
    
    
}
