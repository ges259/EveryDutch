//
//  ReadRoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)

extension RoomsAPI {
    
    typealias RoomUsersCompletion = (Result<[RoomUsers], ErrorEnum>) -> Void
    
    
    func readRoomUsers(
        roomID: String = "room_ID_1",
        completion: @escaping RoomUsersCompletion)
    {
        // 최종적으로 반환될 RoomUsers 배열
        var roomUsers = [RoomUsers]()
        
        ROOM_USERS_REF
            .child(roomID)
            .observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(.readError))
                    return
                }
                for (key, value) in value {
                    // RoomUsers 객체 만들기
                    let roomUser = RoomUsers(
                        userID: key,
                        dictionary: value)
                    // 배열에 추가
                    roomUsers.append(roomUser)
                }
                // 반환
                completion(.success(roomUsers))
            }
        
    }
    
}
