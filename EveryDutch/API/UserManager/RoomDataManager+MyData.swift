//
//  RoomDataManager+MyData.swift
//  EveryDutch
//
//  Created by 계은성 on 7/6/24.
//

import UIKit

extension RoomDataManager {
    
    var myUserData: UserDecoTuple? {
        return self._myUserData
    }
    
    /// EditScreenVM으로 갈 때, 사용하는 튜플
    func getProviderTuple(isUser: Bool) -> ProviderTuple? {
        guard let providerType: EditProviderModel = isUser
                ? self._myUserData?.user
                : self.currentRoom?.room
        else { return nil }
        
        return (provider: providerType,
                deco: self._myUserData?.deco,
                dataID: self.myUserID)
    }
    
    
    
    
    
    // MARK: - 앱 초기 데이터 로드
    /// 유저의 정보(User)가 존재하는지 확인 후, 가져온 데이터는 저장
    func checkMyUserDataIsExist() async throws {
        
        do {
            let user = try await self.userAPI.readMyUserData()
            let deco = try await self.userAPI.fetchDecoration(dataRequiredWhenInEditMode: nil)
            
            self.updateUserData(newUser: user, newDecoration: deco)
            
        } catch let error as ErrorEnum {
            throw error
        } catch {
            throw ErrorEnum.unknownError
        }
    }
    private func updateUserData(newUser: User? = nil,
                                newDecoration: Decoration? = nil
    ) {
        if let newUser = newUser {
            // 새로운 User와 Decoration을 업데이트
            self._myUserData = (
                user: newUser,
                deco: newDecoration ?? self._myUserData?.deco
            )
            
        } else if let currentData = self._myUserData {
            // User는 유지하면서 Decoration만 업데이트
            self._myUserData = (
                user: currentData.user,
                deco: newDecoration
            )
            
        } else {
            print("Error: User data is required before updating decoration")
        }
    }
    
    
    
    
    
    // MARK: - 정산방 초기 데이터 로드
    func startLoadRoomData() {
        // 초기 로드일 때 모든 데이터 초기화
        self.removeRoomsUsersObserver()
        
        self.loadRoomUsers { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success():
//                self.loadFinancialData()
                self.loadRoomReceipt()
                
            case .failure(let error):
                break
            }
        }
    }
}
