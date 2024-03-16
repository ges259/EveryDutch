//
//  FindFriendsVM.swift
//  EveryDutch
//
//  Created by 계은성 on 3/14/24.
//

import Foundation

final class FindFriendsVM: FindFriendsVMProtocol {
    
    private let roomDataManager: RoomDataManagerProtocol
    private let userAPI: UserAPIProtocol
    private let roomsAPI: RoomsAPIProtocol
    
    
    var searchSuccessClosure: ((User) -> Void)?
    var searchFailedClosure: (() -> Void)?
    var inviteSuccessClosure: (() -> Void)?
    var inviteFailClosure: (() -> Void)?
    var userAlreadyExistsClosure: (() -> Void)?
    
    
    
    
    
    
    private var currentUser: RoomUserDataDict?
    
    
    init(roomDataManager: RoomDataManagerProtocol,
         userAPI: UserAPIProtocol,
         roomsAPI: RoomsAPIProtocol) {
        self.roomDataManager = roomDataManager
        self.userAPI = userAPI
        self.roomsAPI = roomsAPI
    }
    
    
    // MARK: - 유저 검색
    func searchUser(text: String?) {
        //
        guard let userID = text, !userID.isEmpty else {
            // 빈킨이거나, 작성하면 안 되는 기호가 있을 때
            self.searchFailedClosure?()
            return
        }
        
        self.userAPI.searchUser(userID) { [weak self] result in
            switch result {
                // 검색 성공
            case .success(let userDict):
                // 딕셔너리의 값을 배열로 변환하고, 첫 번째 User 객체를 사용합니다.
                // userDict은 [String: User] 타입의 딕셔너리입니다.
                guard let user = userDict.values.first else {
                    self?.searchFailedClosure?()
                    return
                }
                self?.currentUser = userDict
                self?.searchSuccessClosure?(user)
                
                
                // 검색 실패.
            case .failure(_):
                self?.currentUser = nil
                self?.searchFailedClosure?()
            }
        }
    }

    
    // MARK: - 유저 초대
    func inviteUser() {
        
        guard let userID: String = self.currentUser?.keys.first,
              let versionID: String = self.roomDataManager.getCurrentVersion,
              let roomID: String = self.roomDataManager.getCurrentRoomsID
        else {
            print("아무것도없음")
            self.inviteFailClosure?()
            return
        }
        
        Task {
            do {
                try await self.roomsAPI.updateNewMember(
                    userID: userID,
                    roomID: roomID,
                    versionID: versionID)
                
                self.inviteSuccessClosure?()
                
                
            } catch let error as ErrorEnum {
                self.handleInviteError(error)
                
                // 예상치 못 한 오류
            } catch {
                self.inviteFailClosure?()
            }
        }
    }
    
    private func handleInviteError(_ error: ErrorEnum) {
        switch error {
        case .userAlreadyExists:
              // 사용자가 이미 존재할 경우의 처리
              print("사용자가 이미 존재합니다.")
            self.userAlreadyExistsClosure?()
              
        case .roomUserUpdateFailed:
            print("RoomUser 에러")
            self.inviteFailClosure?()
            
            
        case .roomUserIDUpdateFailed:
            print("RoomID 에러")
            self.inviteFailClosure?()
            
            
        default: break
        }
    }
}
