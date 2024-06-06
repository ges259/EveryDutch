//
//  DeleteRoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 5/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabaseInternal

extension RoomsAPI {
    func deleteUser(roomID: String, userID: String? = nil) async throws {
        // uid 옵셔널 바인딩
        guard let userID = userID ?? Auth.auth().currentUser?.uid else {
            throw ErrorEnum.readError // 적절한 에러로 변경
        }
        // User_RoomsID 삭제
        try await self.deleteUserRoomsID(roomID: roomID, userID: userID)
        // Room_Users 삭제
        try await self.deleteRoomUsers(roomID: roomID, userID: userID)
    }
    
    private func deleteUserRoomsID(roomID: String, userID: String) async throws {
        return try await self.deleteValue(
            for: USER_ROOMSID.child(userID).child(roomID),
            error: ErrorEnum.userRoomsIDDeleteError
        )
    }
    
    private func deleteRoomUsers(roomID: String, userID: String) async throws {
        return try await self.deleteValue(
            for: ROOM_USERS_REF.child(roomID).child(userID),
            error: ErrorEnum.roomUsersDeleteError
        )
    }
    
    private func deleteValue(for reference: DatabaseReference, error: Error) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            reference.removeValue { removeError, _ in
                if let removeError = removeError {
                    continuation.resume(throwing: removeError)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}

// zOcZ2JZbXYXQ3txd8rxsbcSrVgD3
// -Nykd9zHpN9MmV1EFLpY


