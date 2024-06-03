//
//  CheckUser.swift
//  EveryDutch
//
//  Created by 계은성 on 1/25/24.
//

import Foundation
import FirebaseAuth
import Firebase

final class AuthAPI: AuthAPIProtocol {
    static let shared: AuthAPIProtocol = AuthAPI()
    private init() {}
    
    
     // MARK: - 로그인 여부 확인
     func checkLogin() async throws  {
         if let user = Auth.auth().currentUser {
             // 사용자가 로그인되어 있음
             print("User is logged in: \(user.uid)")
             return
         } else {
             // 사용자가 로그인되어 있지 않음
             print("User is not logged in")
             throw ErrorEnum.NotLoggedIn
         }
     }
    
    // MARK: - 익명 회원가입
    func signInAnonymously() async throws {
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            // 익명 로그인 만들기
            Auth.auth().signInAnonymously { authResult, error in
                // 에러가 떴다면,
                // 유저 아이디 옵셔널 바인딩
                guard error == nil else {
                    continuation.resume(throwing: ErrorEnum.NotLoggedIn)
                    return
                }
                // 유저 아이디가 있다면,
                continuation.resume(returning: ())
            }
        }
    }
}
