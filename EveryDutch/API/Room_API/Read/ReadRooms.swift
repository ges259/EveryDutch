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
    
    // MARK: - 모든 방 가져오기
    func readRooms() async throws -> [Rooms] {
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            throw ErrorEnum.readError
    
        }
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<[Rooms], Error>) in
            // let ROOMS_ID_REF = ref.child("Rooms")
            ROOMS_REF
                .child(uid)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    guard snapshot.exists() else {
                        print("1")
                        // 스냅샷에 데이터가 존재하지 않는 경우, 빈 배열 반환
                        continuation.resume(returning: [])
                        return
                    }
                    print("2")
                    dump(snapshot)
                    guard let valueDict = snapshot.value as? [String: [String: Any]] else {
                        print("3")
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    print("4")
                    var rooms: [Rooms] = []
                    
                    for (roomID, roomInfoDict) in valueDict {
                        let room = Rooms(
                            roomID: roomID,
                            dictionary: roomInfoDict)
                        rooms.append(room)
                    }
                    continuation.resume(returning: rooms)
                }
        }
    }
    
    
    
    
    
    // MARK: - 특정 방 가져오기
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> ProviderModel
    {
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
