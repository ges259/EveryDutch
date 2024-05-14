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
    func loadRoomUsers(completion: @escaping (Result<Void, ErrorEnum>) -> Void) {
        // roomID가져오기
        guard let roomID = self.getCurrentRoomsID else { return }
        
        // 데이터베이스나 네트워크에서 RoomUser 데이터를 가져오는 로직
        self.roomsAPI.readRoomUsers(roomID: roomID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                print("users 성공")
                // [String : RoomUsers] 딕셔너리 저장
                self.updateUsers(with: users)
                self.observeRoomUsers()
                completion(.success(()))
                break
                
            case .failure(let errorEnum):
                print("users 실패")
                completion(.failure(errorEnum))
                break
            }
        }
    }
    
    // MARK: - 옵저버 설정
    private func observeRoomUsers() {
        guard let roomID = self.getCurrentRoomsID else { return }
        
        self.roomsAPI.roomUsersObserver(roomID: roomID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                print("방 옵저버 가져오기 성공")
                self.updateUsers(with: users)
                
                break
            case .failure(_):
                print("방 옵저버 가져오기 실패")
                break
            }
        }
    }
    // MARK: - 업데이트 설정
    private func updateUsers(with usersEvent: DataChangeEvent<[String: User]>) {
        
        switch usersEvent {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            // 리턴할 인덱스패스
            var updatedIndexPaths = [IndexPath]()
            
            for (userID, changedData) in toUpdate {
                if let indexPath = self.userIDToIndexPathMap[userID] {
                    // 뷰모델에 바뀐 user데이터 저장
                    let user = self.usersCellViewModels[indexPath.row].updateUserData(changedData)
                    
                    if let user = user {
                        // [userID: User] 딕셔너리 데이터 업데이트
                        self.roomUserDataDict[userID] = user
                        updatedIndexPaths.append(indexPath)
                    }
                }
            }
            self.postNotification(name: .userDataChanged,
                                  eventType: .updated,
                                  indexPath: updatedIndexPaths)
            
            
            // 데이터 초기 로드
        case .initialLoad(let userDict):
            print("\(#function) ----- init")
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()

            // 초기 로드일 때 모든 데이터 초기화
            self.usersCellViewModels.removeAll()
            self.userIDToIndexPathMap.removeAll()
            // [userID: User] 딕셔너리 데이터 저장
            self.roomUserDataDict = userDict
            
            // 모든 데이터 추가
            for (index, (userID, user)) in userDict.enumerated() {
                // 인덱스 패스 생성
                let indexPath = IndexPath(row: index, section: 0)
                // 뷰모델 생성
                let viewModel = UsersTableViewCellVM(
                    userID: userID,
                    roomUsers: user,
                    customTableEnum: .isSettleMoney)
                // 뷰모델 저장
                self.usersCellViewModels.append(viewModel)
                // 인덱스패스 저장
                self.userIDToIndexPathMap[userID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            self.postNotification(name: .userDataChanged,
                                  eventType: .initialLoad,
                                  indexPath: addedIndexPaths)
            
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            // 리턴할 인덱스패스
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
                // [userID: User] 딕셔너리 데이터 업데이트
                self.roomUserDataDict[userID] = user
                addedIndexPaths.append(indexPath)
            }
            self.postNotification(name: .userDataChanged,
                                  eventType: .added,
                                  indexPath: addedIndexPaths)
            
            
        case .removed(let userID):
            print("\(#function) ----- remove")
            // 리턴할 인덱스패스
            var removedIndexPaths = [IndexPath]()

            if let indexPath = self.userIDToIndexPathMap[userID] {
                // 뷰모델 삭제
                self.usersCellViewModels.remove(at: indexPath.row)
                // 인덱스패스 삭제
                self.userIDToIndexPathMap.removeValue(forKey: userID)
                // [String: User] 데이터 삭제
                self.roomUserDataDict.removeValue(forKey: userID)
                removedIndexPaths.append(indexPath)
                // 삭제 후 인덱스 재정렬 (인덱스 매핑 최적화)
                for row in indexPath.row..<self.usersCellViewModels.count {
                    let newIndexPath = IndexPath(row: row, section: 0)
                    let userID = self.usersCellViewModels[row].userID
                    self.userIDToIndexPathMap[userID] = newIndexPath
                }
            }
            self.postNotification(name: .userDataChanged,
                                  eventType: .removed,
                                  indexPath: removedIndexPaths)
        }
    }
}

