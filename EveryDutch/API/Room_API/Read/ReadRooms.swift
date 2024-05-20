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
    func readRooms(completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void) {
        // 유저ID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            completion(.failure(.readError))
            return
        }
        
        
        var returnRooms = [String: Rooms]()
        // roomID를 가져오기 위한 path
        let roomIDPaths = USER_ROOMSID.child(uid)
        
        let saveGroup = DispatchGroup()
        
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
                self.readRoomsData(roomID: key) { [weak self] result in
                    guard let self = self else {
                        saveGroup.leave()
                        return
                    }
                    switch result {
                    case .success(let room):
                        returnRooms[key] = room
                        // 각 RoomID에 옵저버 설정
                        self.setRoomsDataObserver(roomID: key, completion: completion)
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
    
    // MARK: - Rooms 데이터 fetch
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
    
    
    
    
    // MARK: - Rooms 옵저버
    // 개별 사용자의 데이터 변경을 관찰하는 함수
    private func setRoomsDataObserver(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    {
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
    
    
    
    
    // MARK: - Users_RoomsID 옵저버
    func setRoomObserver(completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    {
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
            self.readRoomsData(roomID: roomID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let room):
                    completion(.success(.added([roomID: room])))
                    // 새로 생긴 RoomID에 옵저버 설정
                    self.setRoomsDataObserver(roomID: roomID, completion: completion)
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
