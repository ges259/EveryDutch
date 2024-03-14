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
        completion: @escaping Typealias.UserCompletion)
    {
        
        print(userID)
        USER_REF
            .queryOrdered(byChild: DatabaseConstants.personal_ID)
            .queryEqual(toValue: userID)
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                dump(snapshot)
                // userID로 직접 접근하는 경우 여기서 바로 createUserFromSnapshot을 사용 가능
//                if snapshot.exists() {
//                    self.createUserFromSnapshot(snapshot, completion: completion)
//                    print("\(#function) - 존재 O")
//                } else {
//                    print("\(#function) - 존재 X")
//                    completion(.failure(.userNotFound))
//                }
                guard let dataSnapshot = snapshot.children.allObjects.first as? DataSnapshot
                else {
                    completion(.failure(.userNotFound))
                    return
                }
                
                self.createUserFromSnapshot(dataSnapshot, completion: completion)
            }
    }
}
