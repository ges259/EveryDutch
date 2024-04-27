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
    

    func createData(dict: [String: Any]) async throws  -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation 
        { (continuation: CheckedContinuation<String, Error>) in
            USER_REF
                .child(uid)
                .updateChildValues(dict) { error, _ in
                    if let _ = error {
                        continuation.resume(throwing: ErrorEnum.unknownError)
                    } else {
                        continuation.resume(returning: uid)
                    }
                }
        }
    }
    
    
    func updateData(dict: [String: Any]) {
        
    }
    
    
    
}
