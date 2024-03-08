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
        
        var roomUsers = [String : RoomUsers]()
        
        let saveGroup = DispatchGroup()
        
        ROOM_USERS_REF
            .child(roomID)
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                
                guard let value = snapshot.value as? [String: Bool] else {
                    print("실패1")
                    completion(.failure(.readError))
                    return
                }
                print("성공1")
                for (key, _) in value {
                    saveGroup.enter()
                    
                    print("성공2")
                    print(key)
                    USER_REF
                        .child(key)
                        .observeSingleEvent(of: .value) { snapshot in
                            
                            guard let valueData = snapshot.value as? [String: Any] else {
                                print("실패2")
                                completion(.failure(.readError))
                                return
                            }
                            print("성공3")
                            print(valueData)
                            let roomUser = RoomUsers(dictionary: valueData)
                            roomUsers[key] = roomUser
                            saveGroup.leave()
                        }
                }
                saveGroup.notify(queue: .main) {
                    print("끝")
                    print(roomUsers)
                    completion(.success(roomUsers))
                }
            }
    }
}
