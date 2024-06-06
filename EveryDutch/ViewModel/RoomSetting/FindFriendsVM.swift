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
    
    private func handleResult<T>(
        _ result: Result<T, ErrorEnum>,
        successAction: @escaping (T) -> Void
    ) {
        DispatchQueue.main.async {
            switch result {
            case .success(let value):
                successAction(value)
            case .failure(let error):
                self.apiErrorClosure?(error)
            }
        }
    }
}










// MARK: - 유저 검색
extension FindFriendsVM {
    func searchUser(text: String?) {
        Task { await self.performSearchUser(text: text) }
    }
    
    /// 유저 검색
    private func performSearchUser(text: String?) async {
        let result: Result<User, ErrorEnum>
        do {
            guard let userID = text, !userID.isEmpty else {
                throw ErrorEnum.searchIdError
            }
            // 빈칸이거나 특수 기호가 있다면 throw
            try await self.isValidUserID(userID)
            
            // 유저 검색
            let userDict = try await self.userAPI.searchUser(userID)
            // 유저 딕셔너리 저장 및 유저 데이터 가져오기
            let user = try await self.updateCurrentUser(userDict)
            result = .success(user)
            
        } catch let error as ErrorEnum {
            result = .failure(error)
            
        } catch {
            result = .failure(.unknownError)
        }
        
        self.handleResult(result) { [weak self] user in
            guard let self = self else { return }
            // 성공 처리 및 현재 사용자 업데이트
            self.searchSuccessClosure?(user)
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
    
    /// 유저 딕셔너리 저장 및 유저 데이터 가져오기
    private func updateCurrentUser(_ userDict: [String: User]) async throws -> User {
        // 가져온 유저 데이터 옵셔널 바인딩
        guard let user = userDict.values.first else {
            throw ErrorEnum.searchFailed
        }
        // 가져온 유저 데이터를 저장
        self.currentUser = userDict
        return user
    }
}
    
 








// MARK: - 유저 초대
extension FindFriendsVM {
    func inviteUser() {
        Task { await self.performInviteUser() }
    }

    private func performInviteUser() async {
        let result: Result<Void, ErrorEnum>
        do {
            guard let userID = self.currentUser?.keys.first,
                  let roomID = self.roomDataManager.getCurrentRoomsID
            else {
                throw ErrorEnum.roomDataError
            }
            try await self.roomsAPI.updateNewMember(
                userID: userID,
                roomID: roomID)
            result = .success(())
            
        } catch let error as ErrorEnum {
            result = .failure(error)
            
        } catch {
            result = .failure(.unknownError)
        }
        
        self.handleResult(result) { [weak self] _ in
            guard let self = self else { return }
            self.inviteSuccessClosure?()
        }
    }
}
