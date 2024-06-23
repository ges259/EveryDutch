//
//  RoomDataManager+SearchReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 6/13/24.
//

import Foundation

extension RoomDataManager {
    
    // MARK: - 강퇴 및 나가기
    func deleteUserFromRoom(
        isDeletingSelf: Bool,
        completion: @escaping Typealias.VoidCompletion
    ) {
        
        Task {
            let result: Result<Void, ErrorEnum>
            do {
                guard let roomID = self.getCurrentRoomsID else {
                    throw ErrorEnum.unknownError
                }
                
                // userID 결정
                let userID: String? = isDeletingSelf
                ? nil
                : self.getCurrentUserID
                
                // 유저 삭제
                try await self.roomsAPI.deleteUser(
                    roomID: roomID,
                    userID: userID)
                
                result = .success(())
            } catch let error as ErrorEnum {
                result = .failure(error)
            } catch {
                result = .failure(.unknownError)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
