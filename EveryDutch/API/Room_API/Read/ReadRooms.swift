//
//  Room_API.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase
import Firebase

// 앱 실행 시
    // 자신이 속한 방 가져오기 ----- (Rooms_ID)
    // user - 방 데이터 가져오기 ----- (Rooms_Thumbnail)
extension RoomsAPI {
    
    func readRooms(completion: @escaping (Result<UserEvent<[Rooms]>, ErrorEnum>) -> Void) {
        // 유저ID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            completion(.failure(.readError))
            return
        }
        
        let saveGroup = DispatchGroup()
        
        var returnRooms = [Rooms]()
        
        // roomID를 가져오기 위한 path
        let roomIDPaths = USER_ROOMSID.child(uid)
        // roomID가져오기
        roomIDPaths.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                // 스냅샷에 데이터가 존재하지 않는 경우, 빈 배열 반환
                completion(.success(.initialLoad([])))
                return
            }
            guard let value = snapshot.value as? [String: Int] else {
                completion(.failure(.readError))
                return
            }
            
            for key in value.keys {
                saveGroup.enter()
                
                self.readRoomsData(roomID: key) { result in
                    switch result {
                    case .success(let room):
                        returnRooms.append(room)
                    case .failure(_):
                        break
                    }
                    saveGroup.leave()
                }
            }
            
            saveGroup.notify(queue: .main) {
                completion(.success(.initialLoad(returnRooms)))
            }
        }
    }
    private func readRoomsData(
        roomID: String,
        completion: @escaping (Result<Rooms, ErrorEnum>) -> Void)
    {
        let path = ROOMS_REF.child(roomID)
        
        path.observeSingleEvent(of: .value) { snapshot in
            guard let valueDict = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            // Rooms 객체 생성
            let room = Rooms(roomID: roomID, dictionary: valueDict)
            completion(.success(room))
        }
    }
    
    
//    // 개별 사용자의 데이터 변경 및 삭제를 관찰하는 함수
//    private func observeRoomChanges(
//        userID: String,
//        completion: @escaping (Result<UserEvent, ErrorEnum>) -> Void) {
//        
//    }
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 모든 방 가져오기
    func readRooms() async throws -> [Rooms] {
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            throw ErrorEnum.readError
    
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<[Rooms], Error>) in
            // let ROOMS_ID_REF = ref.child("Rooms")
            ROOMS_REF
                .child(uid)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    guard snapshot.exists() else {
                        // 스냅샷에 데이터가 존재하지 않는 경우, 빈 배열 반환
                        continuation.resume(returning: [])
                        return
                    }
                    guard let valueDict = snapshot.value as? [String: [String: Any]] else {
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    var rooms: [Rooms] = []
                    
                    for (roomID, roomInfoDict) in valueDict {
                        let room = Rooms(
                            roomID: roomID,
                            dictionary: roomInfoDict)
                        rooms.append(room)
                    }
                    continuation.resume(returning: rooms)
                }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 특정 방 가져오기
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
    {
//        let userDataDict = try await self.readYourOwnUserData()
//        
//        guard let user = userDataDict.values.first else {
//            throw ErrorEnum.userNotFound
//        }
//        
//        let data = try await self.fetchDecoration(dataRequiredWhenInEidtMode: "")
        
        return Rooms(roomID: "", dictionary: [:])
    }
}
