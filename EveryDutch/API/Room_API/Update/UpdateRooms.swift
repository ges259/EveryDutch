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
        roomID: String
    ) async throws {
        try await checkUserInRoom(userID: userID, roomID: roomID)
        try await updateRoomsID(userID: userID, roomsID: roomID)
        try await updateRoomUsers(userID: userID, roomsID: roomID)
    }
    
    private func checkUserInRoom(userID: String, roomID: String) async throws {
        let exists: Bool = await withCheckedContinuation { continuation in
            ROOM_USERS_REF
                .child(roomID)
                .child(userID)
                .observeSingleEvent(of: .value) { snapshot in
                    continuation.resume(returning: snapshot.exists())
                }
        }
        
        if exists {
            print("이미 존재하는 유저")
            throw ErrorEnum.userAlreadyExists
        }
    }
    
    // User_RoomsID에 저장
    private func updateRoomsID(userID: String, roomsID: String) async throws {
        try await updateFirebaseData(
            path: USER_ROOMSID.child(userID),
            values: [roomsID: 0],
            errorEnum: .roomUserIDUpdateFailed)
    }
    
    // Room_Users에 저장
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
