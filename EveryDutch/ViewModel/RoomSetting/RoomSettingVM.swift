//
//  RoomSettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

final class RoomSettingVM: RoomSettingVMProtocol {
    private let roomDataManager: RoomDataManagerProtocol
    private let roomsAPI: RoomsAPIProtocol
    
    var successLeaveRoom: (() -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    init(roomDataManager: RoomDataManagerProtocol,
         roomsAPI: RoomsAPIProtocol) {
        self.roomDataManager = roomDataManager
        self.roomsAPI = roomsAPI
    }
    
    
    
    
    /// 사용자가 roomManager인지를 알려주는 변수
    var checkIsRoomManager: Bool {
        return self.roomDataManager.checkIsRoomManager
    }
     
    
    
    var getCurrentRoomID: String? {
        return self.roomDataManager.getCurrentRoomsID
    }
    
    
    func leaveRoom() {
        Task {
            let result: Result<Void, ErrorEnum>
            do {
                guard let roomID = self.roomDataManager.getCurrentRoomsID else {
                    throw ErrorEnum.unknownError
                }
                // 유저 삭제
                try await self.roomsAPI.deleteUser(roomID: roomID, userID: nil)
                result = .success(())
            } catch let error as ErrorEnum {
                result = .failure(error)
            } catch {
                result = .failure(.unknownError)
            }

            self.handleResult(result)
        }
    }
    private func handleResult(_ result: Result<Void, ErrorEnum>) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.successLeaveRoom?()
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
}
