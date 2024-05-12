//
//  ReadRoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase

import FirebaseAuth

enum UserEvent<T> {
    case added([String: T])
    case removed(String)
    case updated([String: [String: Any]])
    
    case initialLoad([String: T])
}


// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)

extension RoomsAPI {
    // MARK: - observeSingleEvent
    func readRoomUsers(
        roomID: String,
        completion: @escaping (Result<UserEvent<User>, ErrorEnum>) -> Void)
    {
        // 반환될 RoomUsers 배열
        var roomUsers = [String : User]()
        let roomUsersRef = ROOM_USERS_REF.child(roomID)
        
        let saveGroup = DispatchGroup()
        
        // 방에 대한 전체 사용자 데이터를 초기 로드
        roomUsersRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Bool] else {
                completion(.failure(.readError))
                return
            }
            for key in value.keys {
                saveGroup.enter()
                
                self.fetchUserData(userID: key) { result in
                    switch result {
                    case .success(let user):
                        roomUsers[key] = user
                    case .failure:
                        completion(.failure(.readError))
                    }
                    saveGroup.leave()
                }
            }
            saveGroup.notify(queue: .main) {
                completion(.success(.initialLoad(roomUsers)))
            }
        }
    }
    
    // 개별 사용자 데이터 가져오기
    private func fetchUserData(
        userID: String,
        completion: @escaping (Result<User, ErrorEnum>) -> Void)
    {
        let path = USER_REF.child(userID)
        
        path.observeSingleEvent(of: .value) { snapshot in
            guard let valueData = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            // User 객체 생성
            let user = User(dictionary: valueData)
            completion(.success(user))
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - observe
    func observeRoomAndUsers(
        roomID: String,
        userIDs: [String],
        completion: @escaping (Result<UserEvent<User>, ErrorEnum>) -> Void)
    {
        self.setObserveUsers(userIDs: userIDs, completion: completion)
        self.setObserveRoomUsers(roomID: roomID, completion: completion)
    }
    private func setObserveUsers(
        userIDs: [String],
        completion: @escaping (Result<UserEvent<User>, ErrorEnum>) -> Void)
    {
        
        for userID in userIDs {
            let userPath = USER_REF.child(userID)
            
            // 노드 변경 시
            userPath.observe(.childChanged) { snapshot in
                guard let valueData = snapshot.value as? String else {
                    completion(.failure(.readError))
                    return
                }
                
                let value = [snapshot.key: valueData]
                completion(.success(.updated( [userID: value] )))
            }
            
            // 노드 삭제 시
            userPath.observe(.childRemoved) { _ in
                completion(.success(.removed(userID)))
            }
        }
    }
    
    private func setObserveRoomUsers(
        roomID: String,
        completion: @escaping (Result<UserEvent<User>, ErrorEnum>) -> Void)
    {
        let roomUsersRef = ROOM_USERS_REF.child(roomID)
        // 사용자 추가에 대한 옵저버
        roomUsersRef.observe(.childAdded) { snapshot in
            guard let userID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }

            self.fetchUserData(userID: userID) { result in
                switch result {
                case .success(let user):
                    completion(.success(.added([userID: user])))
                case .failure:
                    completion(.failure(.readError))
                }
            }
        }
        // 사용자 제거에 대한 옵저버
        roomUsersRef.observe(.childRemoved) { snapshot in
            guard let userID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            completion(.success(.removed(userID)))
        }
    }
    
    func removeRoomUsersAndUserObserver() {
        ROOM_USERS_REF.removeAllObservers()
        USER_REF.removeAllObservers()
        PAYBACK_REF.removeAllObservers()
        CUMULATIVE_AMOUNT_REF.removeAllObservers()
    }
    // roomID: String, usersKeys: [String]
}


 
