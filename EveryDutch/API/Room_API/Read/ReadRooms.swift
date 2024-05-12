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
    
    // MARK: - observeSingleEvent
    func readRooms(completion: @escaping (Result<UserEvent<Rooms>, ErrorEnum>) -> Void) {
        // 유저ID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            completion(.failure(.readError))
            return
        }
        
        let saveGroup = DispatchGroup()
        
        var returnRooms = [String: Rooms]()
        
        // roomID를 가져오기 위한 path
        let roomIDPaths = USER_ROOMSID.child(uid)
        // roomID가져오기
        roomIDPaths.observeSingleEvent(of: .value) { snapshot in
            // 존재하는지 확인
            guard snapshot.exists() else {
                // 스냅샷에 데이터가 존재하지 않는 경우, 빈 배열 반환
                completion(.success(.initialLoad([:])))
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
                        print("room 가져오기 성공")

                        print(room)
                        returnRooms[key] = room
                    case .failure(_):
                        print("room 가져오기 실패")
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
    
    
    
    
    
    // MARK: - observe
    // 개별 사용자의 데이터 변경을 관찰하는 함수
    func observeRoomChanges(
        roomIDs: [String],
        completion: @escaping (Result<UserEvent<Rooms>, ErrorEnum>) -> Void)
    {
        self.setObserveRooms(roomIDs: roomIDs, completion: completion)
        self.setObserveUsersRoomsID(completion: completion)
    }
    
    private func setObserveRooms(
        roomIDs: [String],
        completion: @escaping (Result<UserEvent<Rooms>, ErrorEnum>) -> Void)
    {
        for roomID in roomIDs {
            let roomPath = ROOMS_REF.child(roomID)
            
            roomPath.observe(.childChanged) { snapshot in
                guard let value = snapshot.value else {
                    completion(.failure(.readError))
                    return
                }
                
                let returnDict = [snapshot.key: value]
                
                completion(.success(.updated( [roomID: returnDict] )))
            }
        }
    }
    private func setObserveUsersRoomsID(completion: @escaping (Result<UserEvent<Rooms>, ErrorEnum>) -> Void) {
        // 유저ID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            completion(.failure(.readError))
            return
        }
        
        // roomID를 가져오기 위한 path
        let roomIDPaths = USER_ROOMSID.child(uid)
        
        roomIDPaths.observe(.childAdded) { snapshot in
            guard let roomID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            
            self.readRoomsData(roomID: roomID) { result in
                switch result {
                case .success(let room):
                    completion(.success(.added([roomID: room])))
                case .failure(_):
                    completion(.failure(.readError))
                }
            }
        }
        roomIDPaths.observe(.childRemoved) { snapshot in
            guard let userID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            completion(.success(.removed(userID)))
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 특정 방 가져오기
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
    {
        
//        self.readRoomsData(roomID: dataRequiredWhenInEidtMode, completion: )
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
