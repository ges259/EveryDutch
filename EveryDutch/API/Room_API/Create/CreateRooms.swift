//
//  CreateRooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabaseInternal

final class RoomsAPI: RoomsAPIProtocol, DecorationAPIType {
    static let shared: RoomsAPIProtocol = RoomsAPI()
    private init() {}
}


extension RoomsAPI {
    
    // MARK: - ROOMS_ID 생성 및 데이터 설정
    func createData(dict: [String: Any]) async throws  -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw ErrorEnum.readError
        }
        
        let roomID = try await addUserToRoom(uid: uid)
        // Room에 정산방에 대한 데이터 저장
        try await setRoomsData(roomID: roomID, dict: dict)
        // User_RoomsID에 uid를 설정하는 함수
        try await self.createRoomID(with: uid, at: roomID)
        
        return roomID
    }
    
    
    
    func updateData(IdRef: String, dict: [String: Any]) async throws {
        // 버전ID 생성 (현재 시간을 기준)
        let versionID = "\(Int(Date().timeIntervalSince1970))"
        // 딕셔너리에 현재 버전을 넣기
        var updatedDict: [String: Any] = dict
            updatedDict[DatabaseConstants.version_ID] = versionID
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            // 새로운 방 생성 및 정보 업데이트
            ROOMS_REF
                .child(IdRef)
                .updateChildValues(updatedDict) { error, ref in
                    
                    guard error == nil else {
                        continuation.resume(throwing: ErrorEnum.writeError)
                        return
                    }
                    continuation.resume(returning: ())
                }
        }
    }
    
    
    
    
    // MARK: - 정산방 유저 저장
    private func addUserToRoom(uid: String) async throws -> String {
        let ref = ROOM_USERS_REF.childByAutoId()
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<String, Error>) in
            ref.updateChildValues([uid: 0]) { error, _ in
                guard error == nil,
                      let roomID = ref.key
                else {
                    continuation.resume(throwing: ErrorEnum.readError)
                    return
                }
                continuation.resume(returning: roomID)
                
            }
        }
    }
    
    
    
    
    // MARK: - 정산방 데이터 저장
    private func setRoomsData(
        roomID: String,
        dict: [String: Any]) async throws
    {
        
    }
    
    // MARK: - RoomsID 생성 및 저장
    private func createRoomID(
        with uid: String,
        at roomID: String
    ) async throws {
        // path
        let ref = USER_ROOMSID.child(uid)
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            
            ref.updateChildValues([roomID: 0]) { error, ref in
                guard error == nil else {
                    continuation.resume(throwing: ErrorEnum.readError)
                    return
                }
                continuation.resume(returning: ())
            }
        }
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


