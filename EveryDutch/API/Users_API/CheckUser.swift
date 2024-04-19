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
    func checkLogin(completion: @escaping Typealias.VoidCompletion) {
        // 이미 로그인된 상태라면,
        if let _ = Auth.auth().currentUser {
            completion(.success(()))
            print("로그인 된 상태")
            
        // 로그인이 되어있지 않은 상태라면,
        } else {
            print("로그인이 안 된 상태")
            completion(.failure(.loginError))
        }
    }
    
    func checkLogin() async throws {
        guard let user = Auth.auth().currentUser else {
            throw ErrorEnum.NotLoggedIn
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            USER_REF
                .child(user.uid)
                .observeSingleEvent(of: .value) { snapshot in
                    guard snapshot.exists() else {
                        continuation.resume(throwing: ErrorEnum.NoPersonalID)
                        return
                    }
                    // 사용자 ID가 존재하면 정상적으로 계속 진행
                    continuation.resume(returning: ())
                }
        }
    }
    
    
    
    // MARK: - 익명 회원가입
    func signInAnonymously(completion: @escaping Typealias.VoidCompletion) {
        // 익명 로그인 만들기.
        Auth.auth().signInAnonymously { authResult, error in
            // 에러가 떴다면,
            // 유저 아이디 옵셔널 바인딩
            guard error == nil else {
                completion(.failure(.loginError))
                return
            }
            // 유저 아이디가 있다면,
            completion(.success(()))
        }
    }
    
}
