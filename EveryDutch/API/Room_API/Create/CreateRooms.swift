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
    
    // MARK: - ROOMS_ID 생성
    func createData(
        dict: [String: Any],
        completion: @escaping (Result<Rooms?, ErrorEnum>) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.readError))
            return
        }
        
        let roomRef = ROOMS_ID_REF.child(uid).childByAutoId()
        
        let versionID = "\(Int(Date().timeIntervalSince1970))"
        
        roomRef.setValue(versionID) { error, snapshot in
            
            if let _ = error {
                completion(.failure(.readError))
                return
            }
            
            guard let roomID = snapshot.key else {
                completion(.failure(.readError))
                return
            }
            
            self.addUserToRoom(with: roomID,
                               uid: uid) { result in
                switch result {
                case .success():
                    self.updateRoomThumbnail(with: roomID, 
                                             data: dict) { result in
                        switch result {
                        case .success:
                            let rooms = Rooms(roomID: roomID,
                                              versionID: versionID,
                                              dictionary: dict)
                            completion(.success(rooms))
                            
                            
                        case .failure(_):
                            completion(.failure(.loginError))
                        }
                    }
                case .failure(_):
                    completion(.failure(.loginError))
                }
            }
        }
    }
    
    // MARK: - 방 정보 생성
    private func updateRoomThumbnail(
        with roomID: String, 
        data: [String: Any],
        completion: @escaping (Result<Void, ErrorEnum>) -> Void) 
    {
        ROOMS_THUMBNAIL_REF
            .child(roomID)
            .updateChildValues(data) { error, _ in
            if let _ = error {
                completion(.failure(.readError))
                return
            }
            completion(.success(()))
        }
    }
    
    // MARK: - 유저 생성
    private func addUserToRoom(
        with roomID: String, 
        uid: String,
        completion: @escaping (Result<Void, ErrorEnum>) -> Void) 
    {
        ROOM_USERS_REF
            .child(roomID)
            .updateChildValues([uid: true]) { error, _ in
                if let _ = error {
                    completion(.failure(.readError))
                    return
                }
                completion(.success(()))
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


