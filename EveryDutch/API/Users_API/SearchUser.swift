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
    func searchUser(
        _ userID: String,
        completion: @escaping Typealias.RoomUsersCompletion)
    {
        
        USER_REF
            .queryOrdered(byChild: DatabaseConstants.personal_ID)
            .queryEqual(toValue: userID)
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                
                guard let dataSnapshot = snapshot.children.allObjects.first as? DataSnapshot
                else {
                    completion(.failure(.userNotFound))
                    return
                }
                
                self.createUserFromSnapshot(dataSnapshot, completion: completion)
            }
    }
}
