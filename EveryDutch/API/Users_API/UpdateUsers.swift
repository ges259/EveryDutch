//
//  UpdateUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

extension UserAPI {
    
    
    func updateUserProfileImage(
        imageUrl: String
    ) async throws {
        guard let uid = self.getCurrentUserID else { return }
        
        let path = USER_REF
            .child(uid)
            .child(DatabaseConstants.profile_image)
        
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            path.setValue(imageUrl) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
