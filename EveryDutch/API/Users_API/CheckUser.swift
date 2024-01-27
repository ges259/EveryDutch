//
//  CheckUser.swift
//  EveryDutch
//
//  Created by 계은성 on 1/25/24.
//

import Foundation
import FirebaseAuth
import Firebase

extension UserAPI {
    
    // MARK: - 로그인 여부 확인
    func checkLogin(completion: @escaping UserCompletion) {
        // 이미 로그인된 상태라면,
        if let currentUser = Auth.auth().currentUser {
            self.readUser(uid: currentUser.uid, completion: completion)
            
        // 로그인이 되어있지 않은 상태라면,
        } else {
            completion(.failure(.loginError))
        }
    }
    
    // MARK: - 익명 로그인
    func signInAnonymously(completion: @escaping UserCompletion) {
        // 익명 로그인 만들기.
        Auth.auth().signInAnonymously { authResult, error in
            // 에러가 떴다면,
            // 유저 아이디 옵셔널 바인딩
            guard error == nil,
                    let uid = authResult?.user.uid else {
                completion(.failure(.loginError))
                return
            }
            
            // 유저 아이디가 있다면,
            self.readUser(uid: uid, completion: completion)
        }
    }
}
