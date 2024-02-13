//
//  ReadRoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase

// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)

extension RoomsAPI {
    
    
    
    func readRoomUsers(
        roomID: String = "room_ID_1",
        completion: @escaping Typealias.RoomUsersCompletion)
    {
        // 최종적으로 반환될 RoomUsers 배열
        var roomUsers = [String : RoomUsers]()
        
        ROOM_USERS_REF
            .child(roomID)
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(.readError))
                    return
                }
                for (key, value) in value {
                    // RoomUsers 객체 만들기
                    let roomUser = RoomUsers(
                        dictionary: value)
                    // 배열에 추가
                    roomUsers[key] = roomUser
                }
                // 반환
                completion(.success(roomUsers))
            }
    }
}
