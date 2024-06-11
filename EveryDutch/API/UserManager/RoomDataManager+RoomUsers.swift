//
//  RoomDataManager+RoomUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 5/11/24.
//

import UIKit


extension RoomDataManager {
    
    // MARK: - 데이터 fetch
    // 콜백 함수 만들기(completion)
    // SettlementMoneyRoomVM에서 호출 됨
    func loadRoomUsers(completion: @escaping Typealias.VoidCompletion) {
        // roomID가져오기
        guard let roomID = self.getCurrentRoomsID else {
            completion(.failure(.readError))
            return
        }
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.roomUsersObserver(roomID: roomID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let users):
                    
                    self.handleUserEvent(with: users)
                    if self.roomUsersInitialLoad {
                        self.roomUsersInitialLoad = false
                        completion(.success(()))
                    }
                    print("방 옵저버 가져오기 성공")
                    break
                case .failure(let error):
                    completion(.failure(error))
                    print("방 옵저버 가져오기 실패")
                    break
                }
            }
        }
    }
    
    // MARK: - 업데이트 분기처리
    private func handleUserEvent(with usersEvent: DataChangeEvent<[String: User]>) {
        
        switch usersEvent {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedRoomUsersEvent(toUpdate)
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedRoomUsersEvent(toAdd)
            
        case .removed(let userID):
            print("\(#function) ----- remove")
            self.handleRemovedRoomUsersEvent(userID)
            // 데이터 초기 로드
        case .initialLoad(_):
            print("\(#function) ----- init ----- error")
            break
        }
    }
    
    
    
    
    // MARK: - 업데이트
    private func handleUpdatedRoomUsersEvent(_ toUpdate: [String: [String: Any]]) {
        // 리턴할 인덱스패스
        var updatedIndexPaths = [IndexPath]()
        
        for (userID, changedData) in toUpdate {
            if let indexPath = self.userIDToIndexPathMap[userID] {
                // 뷰모델에 바뀐 user데이터 저장
                self.usersCellViewModels[indexPath.row].updateUserData(changedData)
                updatedIndexPaths.append(indexPath)
            }
        }
        self.userDebouncer.triggerDebounceWithIndexPaths(eventType: .updated, updatedIndexPaths)
    }
    // MARK: - 생성
    private func handleAddedRoomUsersEvent(_ toAdd: [String: User]) {
        var addedIndexPaths = [IndexPath]()
        
        for (userID, user) in toAdd {
            // 중복 추가 방지
            guard self.userIDToIndexPathMap[userID] == nil else { continue }
            // 인덱스패스 생성
            let indexPath = IndexPath(row: self.usersCellViewModels.count, section: 0)
            // 뷰모델 생성
            let viewModel = UsersTableViewCellVM(
                userID: userID,
                roomUsers: user,
                customTableEnum: .isSettleMoney)
            // 뷰모델 저장
            self.usersCellViewModels.append(viewModel)
            // 인덱스패스 업데이트
            self.userIDToIndexPathMap[userID] = indexPath
            // 생성할 인덱스패스를 저장
            addedIndexPaths.append(indexPath)
        }
        // 디바운싱 트리거
        self.userDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
    }
    
    // MARK: - 삭제
    private func handleRemovedRoomUsersEvent(_ userID: String) {
        // 리턴할 인덱스패스
        var removedIndexPaths = [IndexPath]()

        if let indexPath = self.userIDToIndexPathMap[userID] {
            // 뷰모델 삭제
            self.usersCellViewModels.remove(at: indexPath.row)
            // 인덱스패스 삭제
            self.userIDToIndexPathMap.removeValue(forKey: userID)
            removedIndexPaths.append(indexPath)
            // 삭제 후 인덱스 재정렬 (인덱스 매핑 최적화)
            for row in indexPath.row..<self.usersCellViewModels.count {
                let newIndexPath = IndexPath(row: row, section: 0)
                let userID = self.usersCellViewModels[row].userID
                self.userIDToIndexPathMap[userID] = newIndexPath
            }
        }
        self.userDebouncer.triggerDebounceWithIndexPaths(eventType: .removed, removedIndexPaths)
    }
}
