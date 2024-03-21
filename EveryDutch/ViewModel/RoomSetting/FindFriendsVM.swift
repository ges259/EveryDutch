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
    var showAPIFailedAlertClosure: ((AlertEnum) -> Void)?
    
    
    
    
    
    
    
    
    
    
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
    func searchUser(text: String?) async {
        guard let userID = text, !userID.isEmpty else {
            await notifyError(.searchIdError)
            return
        }
        // 빈킨이거나 특수 기호가 있다면, 리턴
        if await !(self.isValidUserID(userID)) { return }
        
        // 유저 검색
        do {
            let userDict = try await userAPI.searchUser(userID)
            guard let user = userDict.values.first else {
                await notifyError(.searchFailed)
                return
            }
            await updateCurrentUser(userDict, with: user)
        } catch {
            await notifyError(.userNotFound)
        }
    }
    
    // MARK: - 유효성 검사
    private func isValidUserID(_ userID: String) async -> Bool {
        // 띄어쓰기 검사
        if userID.contains(where: { $0.isWhitespace }) {
            await notifyError(.containsWhitespace)
            return false
        }

        // 특수 문자 검사 (알파벳, 숫자, 밑줄(_) 허용)
        let allowedCharacters = CharacterSet.alphanumerics.union(.init(charactersIn: "_"))
        if !CharacterSet(charactersIn: userID).isSubset(of: allowedCharacters) {
            await notifyError(.invalidCharacters)
            return false
        }

        return true
    }
    
    // MARK: - 유저 초대
    func inviteUser() async {
        guard let userID = currentUser?.keys.first,
              let versionID = roomDataManager.getCurrentVersion,
              let roomID = roomDataManager.getCurrentRoomsID 
        else {
            await notifyError(.roomDataError)
            return
        }
            
        do {
            try await roomsAPI.updateNewMember(userID: userID, roomID: roomID, versionID: versionID)
            await MainActor.run { self.inviteSuccessClosure?() }
        } catch let error as ErrorEnum {
            await notifyError(error)
        } catch {
            await notifyError(.unknownError)
        }
    }
    
    // MARK: - 에러 처리
    @MainActor
    private func notifyError(_ error: ErrorEnum) async {
        switch error {
        case .searchFailed, .userNotFound:
            self.apiErrorClosure?(error)
            break
            
        case .searchIdError:
            self.apiErrorClosure?(error)
            self.showAPIFailedAlertClosure?(error.alertType)
            break
            
        case .userAlreadyExists,
                .roomDataError,
                .roomUserUpdateFailed,
                .roomUserIDUpdateFailed,
                .unknownError:
            self.showAPIFailedAlertClosure?(error.alertType)
            break
            
        default:
            break
        }
    }

    // MARK: - 성공 처리 및 현재 사용자 업데이트
    @MainActor
    private func updateCurrentUser(_ userDict: [String: User], with user: User) async {
        self.currentUser = userDict
        self.searchSuccessClosure?(user)
    }
}
