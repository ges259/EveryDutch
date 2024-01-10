//
//  ReadUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit
import FirebaseAuth
import Firebase
// Create
    // 유저 생성
// Read
    // 유저 데이터 가져오기 ----- (Users)
// Update
    // 유저 데이터 수정 ----- (Users)
        // - 닉네임
        // - 이미지
// Delete
    // 회원 탈퇴 시 유저 삭제 ----- (Users)



extension UserAPI {
    
    func readUser(completion: @escaping UserCompletion) {
//        guard let uid = Auth.auth().currentUser else { return }
        
//        USER_REF
//            .child("qqqqqq")
//            .observe(.value) { snapshot  in
//                
//                guard let value = snapshot.value as? [String: Any] else {
//                    completion(.failure(.readError))
//                    print("Error")
//                    return
//                }
//                let data: [String: Any?] = [
//                    "email": value[DatabaseEnum.email],
//                    "inviteID": value[DatabaseEnum.invite_ID],
//                    "userName": value[DatabaseEnum.user_name],
//                    "userProfile": value[DatabaseEnum.user_img],
//                ]
//
//                completion(.success(data))
//
//            }
    }
    

    func readUser2(completion: @escaping UserCompletion) {
//        guard let uid = Auth.auth().currentUser else { return }
        
        USER_REF
            .child("qqqqqq")
            .observe(.value) { snapshot  in
                
                guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(.readError))
                    return
                }
                let user = User(dictionary: value)
                completion(.success(user))
            }
    }
    
    
    
}
