//
//  SelectALoginMethodVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import UIKit

final class SelectALoginMethodVM: SelectALoginMethodVMProtocol {
    
    
    // MARK: - 모델
    var userAPI: AuthAPIProtocol
    
    
    
    // MARK: - 라이프사이클
    init(authAPI: AuthAPIProtocol) {
        self.userAPI = authAPI
    }
    
    
    
    // MARK: - 익명 로그인
    func signInAnonymously(completion: @escaping (Result<Void, ErrorEnum>) -> Void) {
        Task {
            do {
                try await self.userAPI.signInAnonymously()
                completion(.success(()))
            } catch {
                completion(.failure(.NotLoggedIn))
            }
        }
    }
}
