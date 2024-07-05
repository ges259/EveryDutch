//
//  SplashScreenVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import Foundation

final class SplashScreenVM: SplashScreenVMProtocol {
    // MARK: - 모델
    private let userAPI: UserAPIProtocol
    private let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 클로저
    var errorClosure: ((ErrorEnum) -> Void)?
    var successClosure: (() -> Void)?
    
    
    
    // MARK: - 라이프사이클
    init(userAPI: UserAPIProtocol,
         roomDataManager: RoomDataManagerProtocol
    ) {
        self.userAPI = userAPI
        self.roomDataManager = roomDataManager
        self.configureNotification()
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    
    
    
    // MARK: - 노티피케이션
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleRoomDataFetched(notification:)),
            name: .roomDataChanged,
            object: nil
        )
    }
    /// 노티피케이션 함수
    @objc private func handleRoomDataFetched(notification: Notification) {
        if let errorKey = DataChangeType.error.notificationName as String?,
            notification.userInfo?.keys.contains(errorKey) == true {
             if let error = notification.userInfo?[errorKey] as? ErrorEnum {
                 self.errorClosure?(error)
             } else {
                 // errorKey는 있지만 실제로 ErrorEnum 타입의 값이 없는 경우에 대한 처리
                 self.errorClosure?(.unknownError)
             }
         } else {
             // 내 정보가 존재하는지 확인
             // 존재한다면, 메인 화면(MainVC)으로 이동
             // 존재하지 않다면, 유저 데이터 생성 화면(EditScreenVC)으로 이동
             self.checkMyUserDataIsExist()
         }
    }
    
    
    
    // MARK: - API
    /// 로그인이 되어있는지 확인.
    /// 로그인이 되어있다면 -> MainVC로 이동.
    /// 로그인이 되어있찌 않다면 -> SelectALoginMethodVC로 이동
    func checkLogin() {
        Task {
            do {
                // 로그인이 되어있는지 확인하기
                try await self.userAPI.checkLogin()
                // 방 데이터 가져오기
                self.roomDataManager.loadRooms()
                
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
            } catch {
                self.errorClosure?(ErrorEnum.unknownError)
            }
        }
    }
    /// 유저의 정보(User)가 존재하는지 확인 후, 가져온 데이터는 저장
    func checkMyUserDataIsExist() {
        Task {
            do {
                let user = try await self.userAPI.readMyUserData()
                self.roomDataManager.updateUser(newUser: user)
                self.successClosure?()
                
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
                
            } catch {
                self.errorClosure?(.unknownError)
            }
        }
    }
}
