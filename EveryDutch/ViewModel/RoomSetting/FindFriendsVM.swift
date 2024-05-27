//
//  FindFriendsVM.swift
//  EveryDutch
//
//  Created by 계은성 on 3/14/24.
//

import Foundation

final class FindFriendsVM: FindFriendsVMProtocol {
    
    // MARK: - 모델
    private let roomDataManager: RoomDataManagerProtocol
    private let userAPI: UserAPIProtocol
    private let roomsAPI: RoomsAPIProtocol
    private var currentUser: RoomUserDataDict?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 클로저
    var searchSuccessClosure: ((User) -> Void)?
    var inviteSuccessClosure: (() -> Void)?
    var apiErrorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         userAPI: UserAPIProtocol,
         roomsAPI: RoomsAPIProtocol) {
        self.roomDataManager = roomDataManager
        self.userAPI = userAPI
        self.roomsAPI = roomsAPI
    }
}










// MARK: - API

extension FindFriendsVM {
    
    // MARK: - 유저 검색
    func searchUser(text: String?) {
        Task { await self.performSearchUser(text: text) }
    }
    
    /// 유저 검색
    private func performSearchUser(text: String?) async {
        
        do {
            guard let userID = text, !userID.isEmpty else {
                throw ErrorEnum.searchIdError
            }
            // 빈칸이거나 특수 기호가 있다면 throw
            try await self.isValidUserID(userID)
            
            // 유저 검색
            let userDict = try await self.userAPI.searchUser(userID)
            // 가져온 유저 데이터 옵셔널 바인딩
            guard let user = userDict.values.first else {
                throw ErrorEnum.searchFailed
            }
            // 가져온 유저 데이터를 저장
            await self.updateCurrentUser(userDict, with: user)
            
        } catch let error as ErrorEnum {
            self.error(error)
        } catch {
            self.error(.unknownError)
        }
    }
    
    /// 유효성 검사
    private func isValidUserID(_ userID: String) async throws {
        // 띄어쓰기 검사
        if userID.contains(where: { $0.isWhitespace }) {
            throw ErrorEnum.containsWhitespace
        }

        // 특수 문자 검사 (알파벳, 숫자, 밑줄(_) 허용)
        let allowedCharacters = CharacterSet.alphanumerics.union(.init(charactersIn: "_"))
        let userIDCharacterSet = CharacterSet(charactersIn: userID)
        
        if !allowedCharacters.isSuperset(of: userIDCharacterSet) {
            throw ErrorEnum.invalidCharacters
        }
    }
    
    /// 성공 처리 및 현재 사용자 업데이트
    private func updateCurrentUser(_ userDict: [String: User], with user: User) async {
        DispatchQueue.main.async {
            self.currentUser = userDict
            self.searchSuccessClosure?(user)
        }
    }

    
    
    
    
    // MARK: - 유저 초대
    func inviteUser() {
        Task { await self.performInviteUser() }
    }

    private func performInviteUser() async {
        do {
            guard let userID = self.currentUser?.keys.first,
                  let roomID = self.roomDataManager.getCurrentRoomsID
            else {
                throw ErrorEnum.roomDataError
            }
            try await self.roomsAPI.updateNewMember(
                userID: userID,
                roomID: roomID)
            
            DispatchQueue.main.async {
                self.inviteSuccessClosure?()
            }
        } catch let error as ErrorEnum {
            self.error(error)
        } catch {
            self.error(.unknownError)
        }
    }
    
    private func error(_ error: ErrorEnum) {
        DispatchQueue.main.async {
            self.apiErrorClosure?(error)
        }
    }
}
