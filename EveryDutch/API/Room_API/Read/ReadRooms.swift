//
//  Room_API.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase

// 앱 실행 시
    // 자신이 속한 방 가져오기 ----- (Rooms_ID)
    // user - 방 데이터 가져오기 ----- (Rooms_Thumbnail)
extension RoomsAPI {
    
    typealias RoomsIDCompletion = (Result<[Rooms], ErrorEnum>) -> Void
    
    func readRooms(completion: @escaping RoomsIDCompletion) {
        // 비동기 작업들의 완료를 동기화하기 위한 DispatchGroup 객체 생성
        let dispatchGroup = DispatchGroup()
        // 최종적으로 반환될 Rooms 배열
        var rooms: [Rooms] = []
        
        
        ROOMS_ID_REF
            .child("qqqqqq")
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                
                guard let value = snapshot.value as? [String: String] else {
                    // 데이터를 가져오는데 실패한 경우, 에러와 함께 완료 핸들러를 호출
                    completion(.failure(.readError))
                    return
                }
                
                // 가져온 데이터를 순회하며 각 방의 ID와 버전 ID에 대한 정보를 처리
                for (key, versionID) in value {
                    // DispatchGroup에 작업 시작을 알림
                    dispatchGroup.enter()
                    // 각 방의 썸네일 정보를 가져오기 위한 쿼리
                    ROOMS_THUMBNAIL_REF
                        .child(key)
                        .observeSingleEvent(of: DataEventType.value) { snapshot in
                        // 작업이 끝나면 DispatchGroup에 작업 완료를 알림
                        defer { dispatchGroup.leave() }
                        
                        guard let roomInfo = snapshot.value as? [String: String] else {
                            // 데이터를 가져오는데 실패한 경우, 에러와 함께 완료 핸들러를 호출
                            completion(.failure(.readError))
                            return
                        }
                        let room = Rooms(roomID: key,
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
