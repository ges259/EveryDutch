//
//  ReadRoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase

import FirebaseAuth

// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)

extension RoomsAPI {
    
    
    // MARK: - observeSingleEvent
    func readRoomUsers(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)
    {
        // 반환될 RoomUsers 배열
        var roomUsers = [String : User]()
        let roomUsersRef = ROOM_USERS_REF.child(roomID)
        
        let saveGroup = DispatchGroup()
        
        // 방에 대한 전체 사용자 데이터를 초기 로드
        roomUsersRef.observeSingleEvent(of: .value) { snapshot in
            // 존재하는지 확인
            guard snapshot.exists() else {
                // 스냅샷에 데이터가 존재하지 않는 경우, 빈 배열 반환
                completion(.success(.initialLoad([:])))
                return
            }
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
                        self.setObserveUsers(userID: key, completion: completion)
                    case .failure:
                        // 이미 에러를 반환했으므로 추가 에러를 반환하지 않습니다.
                        saveGroup.leave()
                        return
                    }
                    saveGroup.leave()
                }
            }
            saveGroup.notify(queue: .main) {
                completion(.success(.initialLoad(roomUsers)))
            }
        }
        
        // 사용자 추가에 대한 옵저버
        roomUsersRef.observe(.childAdded) { snapshot in
            guard let userID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            self.fetchUserData(userID: userID) { result in
                switch result {
                case .success(let user):
                    print("\(self) ----- \(#function)")
                    completion(.success(.added([userID: user])))
                    self.setObserveUsers(userID: userID, completion: completion)
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
    
    // MARK: - fetch Data
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
    
    // MARK: - observer
    private func setObserveUsers(
        userID: String,
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)
    {
        print("\(self) ----- \(#function)")
        let userPath = USER_REF.child(userID)
        
        // 노드 변경 시
        let childChangedHandle = userPath.observe(.childChanged) { snapshot in
            guard let valueData = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            let dict = [snapshot.key: valueData]
            completion(.success(.updated([userID: dict])))
        }
        
        // 노드 삭제 시
        let childRemovedHandle = userPath.observe(.childRemoved) { _ in
            completion(.success(.removed(userID)))
        }
        
        // 옵저버 핸들을 저장
        userObservers[userID, default: []].append(childChangedHandle)
        userObservers[userID, default: []].append(childRemovedHandle)
    }
    
    // MARK: - removeObserver
    private func removeObservers(forUserID userID: String) {
        guard let handles = userObservers[userID] else { return }
        let userPath = USER_REF.child(userID)
        for handle in handles {
            userPath.removeObserver(withHandle: handle)
        }
        userObservers[userID] = nil
    }

    
    
    
    
    
    func removeRoomUsersAndUserObserver() {
        ROOM_USERS_REF.removeAllObservers()
        USER_REF.removeAllObservers()
        PAYBACK_REF.removeAllObservers()
        CUMULATIVE_AMOUNT_REF.removeAllObservers()
        RECEIPT_REF.removeAllObservers()
    }
}
