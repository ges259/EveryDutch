//
//  CreateRooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabaseInternal

final class RoomsAPI: RoomsAPIProtocol {
    static let shared: RoomsAPIProtocol = RoomsAPI()
    private init() {}
}


extension RoomsAPI {
    
    // MARK: - ROOMS_ID 생성 및 데이터 설정
    func createData(dict: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw ErrorEnum.readError
        }
        let versionID = "\(Int(Date().timeIntervalSince1970))"

        // ROOMS_ID_REF에 versionID를 설정하는 별도의 함수
        let roomID = try await setRoomVersionID(for: uid, versionID: versionID)
        
        // addUserToRoom과 updateRoomThumbnail도 async/await를 사용하여 리팩토링 필요
        try await addUserToRoom(with: roomID, uid: uid)
        try await updateRoomThumbnail(with: roomID, data: dict)
        
//        return Rooms(roomID: roomID, versionID: versionID, dictionary: dict)
    }

    // MARK: - ROOMS_ID_REF에 versionID 설정
    private func setRoomVersionID(
        for uid: String, 
        versionID: String
    ) async throws -> String {
        let roomRef = ROOMS_ID_REF.child(uid).childByAutoId()

        return try await withCheckedThrowingContinuation { continuation in
            roomRef.setValue(versionID) { error, snapshot in
                if error != nil {
                    continuation.resume(throwing: ErrorEnum.readError)
                } else {
                    guard let roomID = snapshot.key else {
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    continuation.resume(returning: roomID)
                }
            }
        }
    }
    
    
    
    // MARK: - 방 정보 생성
    private func updateRoomThumbnail(
        with roomID: String,
        data: [String: Any])
    async throws {
        let ref = ROOMS_THUMBNAIL_REF.child(roomID)
        
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            ref.updateChildValues(data) { error, _ in
                if error != nil {
                    continuation.resume(throwing: ErrorEnum.readError)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - [User] 유저 데이터
    private func addUserToRoom(
        with roomID: String,
        uid: String)
    async throws {
        let ref = ROOM_USERS_REF
            .child(roomID)
        
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            ref.updateChildValues([uid: true]) { error, _ in
                if error != nil {
                    continuation.resume(throwing: ErrorEnum.readError)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    func updateData(dict: [String: Any]) {
        
    }
}


// Create
    // 방 생성 ----- (Rooms_Thumbnail)
        // 생성자의 데이터 저장 ----- (Rooms_ID)
        // 호출: Version_API에서 버전 만들기 ----- (Version_Thumbnail)
    
    
// Read
    // 앱 실행 시
        // 자신이 속한 방 가져오기 ----- (Rooms_ID)
        // user - 방 데이터 가져오기 ----- (Rooms_Thumbnail)
    // 방에 들어섰을 때
        // 방 유저 데이터 가져오기 ----- (Room_Users)
    // 누적 금액 가져오기

// Update
    // 방에 초대 ----- (Rooms_ID)
    // 방 개인 정보 수정 ----- (Rooms_Thumbnail)
        // - user의 이름 바꾸기
        // - user의 이미지 바꾸기
    // 방 정보 수정 ----- (Rooms_Thumbnail)
        // - 방의 이름 바꾸기
        // - 방의 이미지 바꾸기
    // 영수증 작성 시 금액 변경 ----- (Room_Money_Data)
        // - 누적 금액 변경
        // - 받아야 할 돈 변경

// Delete
    // 방에서 나가기 ----- (Room_ID)
        // 강퇴
    // 방에서 모두 나가기
        // 방 삭제
        // 호출: Version_API에서 버전 삭제 ----- (Version_Thumbnail)


