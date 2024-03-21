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
    
    
    func readRoomsID(completion: @escaping Typealias.RoomsIDCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else {
            // 사용자가 로그인하지 않았을 경우의 에러 처리
            completion(.failure(.readError))
            return
        }
        
        ROOMS_ID_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            // 데이터가 존재하지 않는 경우
            guard snapshot.exists() else {
                completion(.success([])) // 빈 배열로 성공 응답
                return
            }
            
            // 데이터 형식이 잘못되었거나 예상과 다른 경우
            guard let value = snapshot.value as? [String: String] else {
                completion(.failure(.readError)) // 예상치 못한 데이터 형식 에러
                return
            }
            
            // 데이터가 비어있는 경우도 처리
            if value.isEmpty {
                completion(.success([])) // 빈 배열로 성공 응답
                return
            }
            
            // 데이터가 존재하고 예상된 형식일 때의 처리
            var rooms: [Rooms] = []
            let dispatchGroup = DispatchGroup()
            
            // 가져온 데이터를 순회하며 각 방의 ID와 버전 ID에 대한 정보를 처리
            for (roomID, versionID) in value {
                // DispatchGroup에 작업 시작을 알림
                dispatchGroup.enter()
                // 각 방의 썸네일 정보를 가져오기 위한 쿼리
                ROOMS_THUMBNAIL_REF
                    .child(roomID)
                    .observeSingleEvent(of: .value) { snapshot in
                        // 작업이 끝나면 DispatchGroup에 작업 완료를 알림
                        defer { dispatchGroup.leave() }
                        
                        guard let roomInfo = snapshot.value as? [String: Any] else {
                            // 썸네일 정보가 예상된 형식이 아니라면 continue로 다음 반복 진행
                            // 실패한 케이스에 대한 별도의 에러 처리를 여기서 할 수 있음
                            completion(.failure(.readError))
                            return
                        }
                        
                        let room = Rooms(roomID: roomID,
                                         versionID: versionID,
                                         dictionary: roomInfo)
                        rooms.append(room)
                    }
            }
            // 모든 비동기 작업이 완료되면 호출될 클로저
            dispatchGroup.notify(queue: .main) {
                // 성공적으로 데이터를 가져왔다면, rooms 배열과 함께 완료 핸들러를 호출
                completion(.success(rooms))
            }
        }
    }
}
