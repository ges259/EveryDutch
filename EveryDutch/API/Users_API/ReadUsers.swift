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
    
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
    {
        guard let decoID = dataRequiredWhenInEidtMode ?? self.getMyUserID else {
            throw ErrorEnum.readError
        }
        
        let userDataDict = try await self.readUser(uid: decoID)
        
        guard let user = userDataDict.values.first else {
            throw ErrorEnum.userNotFound
        }
        return user
    }
    
    
    
    
    
    
    
    // MARK: - User데이터 가져오기
    func readMyUserData() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<User, Error>) in
            USER_REF
                .child(uid)
                .observeSingleEvent(of: .value) { snapshot in
                    guard snapshot.exists(), let userSnap = snapshot.value as? [String: Any] else {
                        continuation.resume(throwing: ErrorEnum.userNotFound)
                        return
                    }
                    
                    let user = User(dictionary: userSnap)
                    continuation.resume(returning: user)
                }
        }
    }
    
    
    // MARK: - 유저 읽기
    func readUser(uid: String) async throws -> [String: User]
    {
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<[String: User], Error>) in
            // 유저데이터 가져오기
            USER_REF.child(uid)
                .observeSingleEvent(of: DataEventType.value) { snapshot  in
                    
                    do {
                        let user = try self.createUserFromSnapshot(snapshot)
                        continuation.resume(returning: user)
                    } catch {
                        continuation.resume(throwing: ErrorEnum.userNotFound)
                    }
                }
        }
    }
    
    
    
    
    // MARK: - User 객체 생성
    // 데이터 스냅샷으로부터 User 객체를 생성하고 반환하는 함수
    func createUserFromSnapshot(_ snapshot: DataSnapshot) throws -> [String: User] {
        guard let value = snapshot.value as? [String: Any] else {
            throw ErrorEnum.readError
        }
        // 유저 모델 만들기
        let user = User(dictionary: value)
        let key = snapshot.key
        let userDict: [String: User] = [key: user]
        return userDict
    }
}
