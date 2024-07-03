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
        
        guard let roomID = dataRequiredWhenInEidtMode ?? self.getMyUserID else {
            throw ErrorEnum.readError
        }
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<EditProviderModel, Error>) in
            
            ROOMS_REF
                .child(roomID)
                .observeSingleEvent(of: .value) { snapshot in
                    guard let valueDict = snapshot.value as? [String: Any] else {
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    // Rooms 객체 생성
                    let room = Rooms(roomID: roomID, dictionary: valueDict)
                    continuation.resume(returning: room)
                }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: - User_RoomsID 옵저버
    func setUserRoomsIDObserver(
        completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            completion(.failure(.readError))
            return
        }
        // roomID를 가져오기 위한 path
        let userRoomsIDPath = USER_ROOMSID.child(uid)
        
        userRoomsIDPath.observe(.childAdded) { snapshot in
            guard let roomID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            self.setRoomsObserver(roomID: roomID, completion: completion)
        }
        
        userRoomsIDPath.observe(.childRemoved) { snapshot in
            guard let userID = snapshot.key as String? else {
                completion(.failure(.readError))
                return
            }
            completion(.success(.removed(userID)))
        }
    }
    
    // MARK: - Rooms 옵저법
    private func setRoomsObserver(
        roomID: String,
        completion: @escaping (Result<DataChangeEvent<[String: Rooms]>, ErrorEnum>) -> Void)
    {
        let roomsPath = ROOMS_REF.child(roomID)
        
        roomsPath.observe(.childChanged) { snapshot in
            guard let value = snapshot.value else {
                print("childChanged ----- Error")
                return
            }
            let returnDict = [snapshot.key: value]
            completion(.success(.updated([roomID: returnDict])))
        }
        roomsPath.observeSingleEvent(of: .value) { snapshot in
            guard let valueDict = snapshot.value as? [String: Any] else {
                print("observeSingleEvent ----- Error")
                completion(.failure(.readError))
                return
            }
            // Rooms 객체 생성
            let room = Rooms(roomID: roomID, dictionary: valueDict)
            completion(.success(.initialLoad([roomID: room])))
        }
    }
}
