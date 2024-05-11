//
//  RoomDataManager+RoomData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/11/24.
//

import Foundation

extension RoomDataManager {
    
    
    // MARK: - 데이터 fetch
    @MainActor
    func loadRooms(completion: @escaping Typealias.VoidCompletion) {
        
        self.roomsAPI.readRooms { result in
            switch result {
            case .success(let initialLoad):
                print("방 가져오기 성공")
                
                self.updateRooms(initialLoad)
                
                
                completion(.success(()))
                break
            case .failure(_):
                print("방 가져오기 실패")
                completion(.failure(.readError))
                break
            }
        }
    }
    
    // MARK: - 옵저버 설정
    private func observeRooms() {    
//        self.roomsAPI.observeRoomChanges(roomIDs: <#T##[String]#>, completion: <#T##(Result<UserEvent<Rooms>, ErrorEnum>) -> Void#>)
    }
    
    // MARK: - 업데이트 설정
    private func updateRooms(_ event: (UserEvent<[Rooms]>)) {
        switch event {
        case .added(_):
            break
        case .removed(_):
            break
        case .updated(_):
            break
        case .initialLoad(let rooms):
            self.rooms = rooms
            
            break
        }
    }
}



