//
//  UpdateRooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabaseInternal

// 유저 닉네임 및 이미지 변경
// 버전 변경



extension RoomsAPI {
    
    func updateNewMember(
        userID: String,
        roomID: String,
        versionID: String
    ) async throws {
        try await checkUserInRoom(userID: userID, roomID: roomID)
        try await updateRoomsID(userID: userID, roomsID: roomID, versionID: versionID)
        try await updateRoomUsers(userID: userID, roomsID: roomID)
    }
    
    private func checkUserInRoom(userID: String, roomID: String) async throws {
        let exists: Bool = await withCheckedContinuation { continuation in
            ROOM_USERS_REF
                .child(roomID)
                .child(userID)
                .observeSingleEvent(of: .value) { snapshot in
                    continuation.resume(returning: snapshot.exists())
                    print("존재O")
                }
        }
        
        if exists {
            print("존재X")
            throw ErrorEnum.userAlreadyExists
        }
    }
    
    private func updateRoomsID(userID: String, roomsID: String, versionID: String) async throws {
        let dict: [String: String] = [roomsID: versionID]
        try await updateFirebaseData(
            path: ROOMS_ID_REF.child(userID),
            values: dict,
            errorEnum: .roomUserIDUpdateFailed)
    }

    private func updateRoomUsers(userID: String, roomsID: String) async throws {
        try await updateFirebaseData(
            path: ROOM_USERS_REF.child(roomsID),
            values: [userID: 0],
            errorEnum: .roomUserUpdateFailed)
    }
    
    
    private func updateFirebaseData(
        path: DatabaseReference,
        values: [String: Any],
        errorEnum: ErrorEnum
    ) async throws {
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            path.updateChildValues(values) { error, _ in
                if let _ = error {
                    continuation.resume(throwing: errorEnum)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
