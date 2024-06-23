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
    
    // MARK: - roomUsers 옵저버
    func roomUsersObserver(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)
    {
        let roomUsersRef = ROOM_USERS_REF.child(roomID)
        // 사용자 추가에 대한 옵저버
        roomUsersRef.observe(.childAdded) { snapshot in
            guard let userID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            self.fetchUserData(userID: userID, completion: completion)
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
        completion: @escaping (Result<DataChangeEvent<[String: User]>, ErrorEnum>) -> Void)
    {
        let path = USER_REF.child(userID)
        
        path.observeSingleEvent(of: .value) { snapshot in
            guard let valueData = snapshot.value as? [String: Any] else {
                completion(.failure(.readError))
                return
            }
            // User 객체 생성
            let user = User(dictionary: valueData)
            
            completion(.success(.added([userID: user])))
        }
        
        // 노드 변경 시
        path.observe(.childChanged) { snapshot in
            guard let valueData = snapshot.value as? String else {
                completion(.failure(.readError))
                return
            }
            let dict = [snapshot.key: valueData]
            completion(.success(.updated([userID: dict])))
        }
        
        // 노드 삭제 시
        path.observe(.childRemoved) { _ in
            completion(.success(.removed(userID)))
        }
    }
    
    
    // MARK: - removeObserver
    func removeRoomUsersAndUserObserver() {
        ROOM_USERS_REF.removeAllObservers()
        USER_REF.removeAllObservers()
        PAYBACK_REF.removeAllObservers()
        CUMULATIVE_AMOUNT_REF.removeAllObservers()
        RECEIPT_REF.removeAllObservers()
    }
}
