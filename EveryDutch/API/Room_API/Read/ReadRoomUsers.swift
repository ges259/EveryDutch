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
    
    func readRoomUsers(
        roomID: String,
        completion: @escaping Typealias.RoomUsersCompletion)
    {
        // 최종적으로 반환될 RoomUsers 배열
        var roomUsers = [String : User]()
        
        let saveGroup = DispatchGroup()
        
        ROOM_USERS_REF
            .child(roomID)
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                
                guard let value = snapshot.value as? [String: Bool] else {
                    completion(.failure(.readError))
                    return
                }
                
                for (key, _) in value {
                    saveGroup.enter()
                    
                    USER_REF
                        .child(key)
                        .observeSingleEvent(of: .value) { snapshot in
                            
                            guard let valueData = snapshot.value as? [String: Any] else {
                                completion(.failure(.readError))
                                return
                            }
                            let roomUser = User(dictionary: valueData)
                            roomUsers[key] = roomUser
                            saveGroup.leave()
                        }
                }
                saveGroup.notify(queue: .main) {
                    completion(.success(roomUsers))
                }
            }
    }
}
