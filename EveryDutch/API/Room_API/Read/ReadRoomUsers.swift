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
    case added(T)
    case removed(String)
    case updated([String: [String: Any]])
    case initialLoad(T)
}


// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)

extension RoomsAPI {
    func readRoomUsers(
        roomID: String,
        completion: @escaping (Result<UserEvent<[String: User]>, ErrorEnum>) -> Void)
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
                
                // 변경 및 삭제 이벤트를 위한 개별 옵저버 등록
                self.observeUserChanges(userID: key, completion: completion)
            }

            saveGroup.notify(queue: .main) {
                completion(.success(.initialLoad(roomUsers)))
            }
        }
        
        // 사용자 추가에 대한 옵저버
        roomUsersRef.observe(.childAdded) { snapshot in
            guard let userID = snapshot.key as String? else { return }

            self.fetchUserData(userID: userID) { result in
                switch result {
                case .success(let user):
                    completion(.success(.added([userID: user])))
                case .failure:
                    break
                }
            }
        }
        
        // 사용자 제거에 대한 옵저버
        roomUsersRef.observe(.childRemoved) { snapshot in
            guard let userID = snapshot.key as String? else { return }
            completion(.success(.removed(userID)))
        }
    }
    
    // 개별 사용자 데이터 가져오기
    private func fetchUserData(
        userID: String,
        completion: @escaping (Result<User, ErrorEnum>) -> Void)
    {
        let path = USER_REF.child(userID)
        
        path.observeSingleEvent(of: .value) { snapshot in
            print("\(#function) --- 1")
            print(snapshot)
            dump(snapshot.value)
            guard let valueData = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            // User 객체 생성
            let user = User(dictionary: valueData)
            completion(.success(user))
        }
    }
    
    // 개별 사용자의 데이터 변경 및 삭제를 관찰하는 함수
    private func observeUserChanges(
        userID: String,
        completion: @escaping (Result<UserEvent<[String: User]>, ErrorEnum>) -> Void)
    {
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

