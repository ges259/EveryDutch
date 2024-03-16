//
//  ReadUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit
import FirebaseAuth
import Firebase
// Create
    // 유저 생성
// Read
    // 유저 데이터 가져오기 ----- (Users)
// Update
    // 유저 데이터 수정 ----- (Users)
        // - 닉네임
        // - 이미지
// Delete
    // 회원 탈퇴 시 유저 삭제 ----- (Users)



extension UserAPI {
    
    // MARK: - 유저 읽기
    func readUser(
        uid: String,
        completion: @escaping Typealias.RoomUsersCompletion)
    {
        // 유저데이터 가져오기
        USER_REF
            .child(uid)
            .observeSingleEvent(of: DataEventType.value) { snapshot  in
                self.createUserFromSnapshot(snapshot, completion: completion)
            }
    }
    
    
    
    // MARK: - User 객체 생성
    // 데이터 스냅샷으로부터 User 객체를 생성하고 반환하는 함수
    func createUserFromSnapshot(
        _ snapshot: DataSnapshot,
        completion: @escaping Typealias.RoomUsersCompletion)
    {
        guard let value = snapshot.value as? [String: Any] else {
            completion(.failure(.readError))
            return
        }
        
        // 유저 모델 만들기
        let user = User(dictionary: value)
        let key = snapshot.key
        let userDict: RoomUserDataDict = [key: user]
        
        // 컴플리션
        completion(.success(userDict))
    }
}
