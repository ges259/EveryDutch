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
    
    func readUser(uid: String, completion: @escaping Typealias.UserCompletion) {
        
        // 유저데이터 가져오기
        USER_REF
            .child(uid)
            .observeSingleEvent(of: DataEventType.value) { snapshot  in
                
                guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(.readError))
                    return
                }
                // 유저 모델 만들기
                let user = User(dictionary: value)
                // 컴플리션
                completion(.success(user))
            }
    }
}
