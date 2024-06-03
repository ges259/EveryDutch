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
    
    // MARK: - Rooms 데이터 fetch
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
    {
        guard let roomID = dataRequiredWhenInEidtMode else {
            throw ErrorEnum.readError
        }
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<EditProviderModel, Error>) in
            self.readRoomsData(roomID: roomID) { result in
                switch result {
                case .success(let room):
                    continuation.resume(returning: room)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
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
    
    
    // MARK: - User_RoomsID 데이터 fetch
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
                self.readRoomsData(roomID: key) { result in
                    switch result {
                    case .success(let room):
                        returnRooms[key] = room
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
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Rooms 데이터 옵저버
    
    
    
    // MARK: - Fix
    // 업데이트 시 두 번 호출 됨
    // 개별 사용자의 데이터 변경을 관찰하는 함수
    func setRoomsDataObserver(
        roomIDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    {
        for roomID in roomIDs {
            let roomPath = ROOMS_REF.child(roomID)
            roomPath.observe(.childChanged) { snapshot in
                guard let value = snapshot.value else {
                    return
                }
                
                let returnDict = [snapshot.key: value]
                completion(.success(.updated([roomID: returnDict])))
            }
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
    
 
    
    
    
    
    
    

}


// personal_ID
// user_name

// 이미 존재 -> 카드 숨기지 않고 얼럿창만
