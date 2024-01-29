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
    
    
    
    
    
    
    
    
    
    
    // MARK: - 로그인 여부 확인
    func checkLogin(completion: @escaping (Bool) -> Void) {
        self.authAPI.checkLogin { result in
            switch result {
            case .success(_):
                self.fetchRoomsData {
                    completion(true)
                }
                break
                
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    
    func fetchRoomsData(completion: @escaping () -> Void) {
        self.roomDataManager.loadRooms {
            completion()
        }
    }
}
