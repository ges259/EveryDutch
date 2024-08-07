//
//  CreateRooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabaseInternal

final class RoomsAPI: RoomsAPIProtocol, DecorationAPI {

    
    static let shared: RoomsAPIProtocol = RoomsAPI()
    private init() {}
}


extension RoomsAPI {
    
    // MARK: - 방 생성
    func createData(dict: [String: Any]) async throws  -> String {
        guard let uid = self.getMyUserID else {
            throw ErrorEnum.readError
        }
        // Room_Users에 데이터 업데이트
        let roomID = try await addUserToRoom(uid: uid)
        // Rooms에 저장할 필수 데이터를 업데이트
        let updatedDict = await self.updateRoomDictData(uid: uid, dict: dict)
        // Rooms에 '정산방'에 대한 데이터 저장
        try await updateData(IdRef: roomID, dict: updatedDict)
        // User_RoomsID에 uid를 설정하는 함수
        try await self.createRoomID(with: uid, at: roomID)
        
        return roomID
    }
    
    // Rooms에 저장할 필수 데이터를 업데이트
    private func updateRoomDictData(
        uid: String,
        dict: [String: Any]
    ) async -> [String: Any] {
        // 파라미터로 전달된 dict를 로컬 변수로 복사
        var dataDict = dict
        dataDict[DatabaseConstants.room_manager] = uid
        // 버전 ID 업데이트
        let versionID = "\(Int(Date().timeIntervalSince1970))"
        dataDict[DatabaseConstants.version_ID] = versionID
        
        return dataDict
    }
    
    // MARK: - RoomUsers
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
    
    // MARK: - RoomsID
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
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Rooms
     private func createRooms(
         roomID: String,
         dict: [String: Any]) async throws
     {
         // 버전ID 생성 (현재 시간을 기준)

         // 딕셔너리에 현재 버전을 넣기
         var updatedDict: [String: Any] = dict
             updatedDict[DatabaseConstants.version_ID] = versionID
         try await self.updateData(IdRef: roomID, dict: dict)
     }
     */
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


