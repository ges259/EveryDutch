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
        
        print("1")
        self.authAPI.checkLogin { result in
            switch result {
            case .success(_):
                print("2")
                self.fetchRoomsData {
                    print("3")
                    completion(true)
                }
                break
                
            case .failure(_):
                print("-1")
                completion(false)
                break
            }
        }
    }
    
    
    func fetchRoomsData(completion: @escaping () -> Void) {
        print("4")
        self.roomDataManager.loadRooms {
            completion()
        }
    }
}
