//
//  SearchUser.swift
//  EveryDutch
//
//  Created by 계은성 on 3/13/24.
//

import Foundation
import FirebaseDatabaseInternal

extension UserAPI {
    
    // MARK: - 유저 검색
    func searchUser(_ userID: String) async throws -> [String: User] {
        
        return try await withCheckedThrowingContinuation 
        { (continuation: CheckedContinuation<[String: User], Error>) in
            USER_REF
                .queryOrdered(byChild: DatabaseConstants.personal_ID)
                .queryEqual(toValue: userID)
                .observeSingleEvent(of: DataEventType.value) { snapshot in
                    
                    guard let dataSnapshot = snapshot.children.allObjects.first as? DataSnapshot 
                    else {
                        continuation.resume(throwing: ErrorEnum.userNotFound)
                        return
                    }
                    
                    do {
                        let user = try self.createUserFromSnapshot(dataSnapshot)
                        continuation.resume(returning: user)
                        
                    } catch {
                        continuation.resume(throwing: ErrorEnum.userNotFound)
                    }
                }
        }
    }
}
