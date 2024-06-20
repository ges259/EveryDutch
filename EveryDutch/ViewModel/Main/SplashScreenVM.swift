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
    
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    init(authAPI: AuthAPIProtocol, roomDataManager: RoomDataManagerProtocol) {
        self.authAPI = authAPI
        self.roomDataManager = roomDataManager
    }
    
    func checkLogin() {
        Task {
            do {
                try await self.authAPI.checkLogin()
                self.roomDataManager.loadRooms()
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
            } catch {
                self.errorClosure?(ErrorEnum.unknownError)
            }
        }
    }
}
