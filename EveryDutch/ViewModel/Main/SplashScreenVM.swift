//
//  SplashScreenVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import Foundation

final class SplashScreenVM: SplashScreenVMProtocol {
    
    private let authAPI: AuthAPIProtocol
    private let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 라이프사이클
    init(authAPI: AuthAPIProtocol,
         roomDataManager: RoomDataManagerProtocol) {
        self.authAPI = authAPI
        self.roomDataManager = roomDataManager
    }
    deinit {
        print("deinit --- \(#function)-----\(self)")
    }
    
    
    // MARK: - 로그인 여부 확인
    func checkLogin(completion: @escaping (Result<(),ErrorEnum>) -> Void) {
        self.authAPI.checkLogin { result in
            switch result {
            case .success():
                self.roomDataManager.loadRooms(completion: completion)
                break
                
            case .failure(let errorEnum):
                completion(.failure(errorEnum))
                break
            }
        }
    }
}
