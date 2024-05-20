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
    var successClosure: (() -> Void)?

    
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
    func checkLogin() {
        Task {
            do {
                try await self.authAPI.checkLogin()
                self.loadRooms()
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
            } catch {
                self.errorClosure?(ErrorEnum.unknownError)
            }
        }
    }
    
    private func loadRooms() {
        self.roomDataManager.loadRooms { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.successClosure?()
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
}
