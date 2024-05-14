//
//  RoomDataManager+RoomData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/11/24.
//

import Foundation

extension RoomDataManager {
    
    // MARK: - 데이터 fetch
    func loadRooms(completion: @escaping Typealias.VoidCompletion) {
        // 방 데이터 가져오기
        self.roomsAPI.readRooms { result in
            switch result {
            case .success(let initialLoad):
                print("방 가져오기 성공")
                DispatchQueue.main.async {
                    self.updateRooms(initialLoad)
                    completion(.success(()))
                }
                break
            case .failure(_):
                print("방 가져오기 실패")
                DispatchQueue.main.async {
                    completion(.failure(.readError))
                }
                break
            }
        }
    }
    
    // MARK: - 옵저버 설정
    private func setObserveRooms(with dict: [String: Rooms]) {
        
        let roomsKey = Array(dict.keys)
        
        guard !roomsKey.isEmpty else { return }
        
        self.roomsAPI.observerRoomsDataChanges(roomIDs: roomsKey) { result in
            switch result {
            case .success(let rooms):
                self.updateRooms(rooms)
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: - 업데이트 설정
    private func updateRooms(_ event: (DataChangeEvent<[String: Rooms]>)) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            // 리턴할 인덱스패스
            var updatedIndexPaths = [IndexPath]()
            
            for (userID, changedData) in toUpdate {
                if let indexPath = self.roomIDToIndexPathMap[userID] {
                    // 뷰모델에 바뀐 user데이터 저장
                    self.roomsCellViewModels[indexPath.row].updateRoomData( changedData)
                    updatedIndexPaths.append(indexPath)
                }
            }
            print("updatedIndexPaths ----- \(updatedIndexPaths)")
            self.postNotification(name: .roomDataChanged,
                                  eventType: .updated,
                                  indexPath: updatedIndexPaths)
            
            
            // 데이터 초기 로드
        case .initialLoad(let roomDict):
            print("\(#function) ----- init")
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()

            // 초기 로드일 때 모든 데이터 초기화
            self.roomsCellViewModels.removeAll()
            self.roomIDToIndexPathMap.removeAll()
            
            // 모든 데이터 추가
            for (index, (roomID, room)) in roomDict.enumerated() {
                // 인덱스 패스 생성
                let indexPath = IndexPath(row: index, section: 0)
                // 뷰모델 생성
                let viewModel = MainCollectionViewCellVM(roomID: roomID,
                                                         room: room)
                // 뷰모델 저장
                self.roomsCellViewModels.append(viewModel)
                // 인덱스패스 저장
                self.roomIDToIndexPathMap[roomID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            // observer 설정
            self.setObserveRooms(with: roomDict)
            print("addedIndexPaths ----- \(addedIndexPaths)")
            self.postNotification(name: .roomDataChanged,
                                  eventType: .initialLoad,
                                  indexPath: addedIndexPaths)
            
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()
            for (roomID, room) in toAdd {
                // 중복 추가 방지
                guard self.roomIDToIndexPathMap[roomID] == nil else { continue }
                // 인덱스패스 생성
                let indexPath = IndexPath(row: self.roomsCellViewModels.count, section: 0)
                // 뷰모델 생성
                let viewModel = MainCollectionViewCellVM(roomID: roomID,
                                                         room: room)
                // 뷰모델 저장
                self.roomsCellViewModels.append(viewModel)
                // 인덱스패스 업데이트
                self.roomIDToIndexPathMap[roomID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            // 가져온 rooms에 대해 observer 설정
//            self.setObserveRooms(with: toAdd)
            print("addedIndexPaths ----- \(addedIndexPaths)")
            self.postNotification(name: .roomDataChanged,
                                  eventType: .added,
                                  indexPath: addedIndexPaths)
            
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            // 리턴할 인덱스패스
            var removedIndexPaths = [IndexPath]()

            if let indexPath = self.roomIDToIndexPathMap[roomID] {
                // 뷰모델 삭제
                self.roomsCellViewModels.remove(at: indexPath.row)
                // 인덱스패스 삭제
                self.roomIDToIndexPathMap.removeValue(forKey: roomID)
                // [String: User] 데이터 삭제
                removedIndexPaths.append(indexPath)
                // 삭제 후 인덱스 재정렬 (인덱스 매핑 최적화)
                for row in indexPath.row..<self.roomsCellViewModels.count {
                    // 새로운 인덱스패스 생성
                    let newIndexPath = IndexPath(row: row, section: 0)
                    // 해당 인덱스의 뷰모델에 있는 roomID를 가져옴
                    let roomID = self.roomsCellViewModels[row].getRoomID
                    self.roomIDToIndexPathMap[roomID] = newIndexPath
                }
            }
            print("removedIndexPaths ----- \(removedIndexPaths)")
            self.postNotification(name: .roomDataChanged,
                                  eventType: .removed,
                                  indexPath: removedIndexPaths)
        }
    }
}



