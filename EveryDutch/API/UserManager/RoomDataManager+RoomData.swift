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
        DispatchQueue.global(qos: .utility).async {
            // 방 데이터 가져오기
            self.roomsAPI.readRooms { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    
                    print("방 가져오기 성공")
                    self.handleRoomEvent(initialLoad)
                    // 옵저버 설정
                    self.observeRoomsID()
                    // Decoration가져오기
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                    break
                case .failure(_):
                    DispatchQueue.main.async {
                        print("방 가져오기 실패")
                        completion(.failure(.readError))
                    }
                    break
                }
            }
        }
    }
    
    // MARK: - 옵저버 설정
    private func observeRoomsID() {
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.setUsersRoomsIDObserver { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let observeData):
                    print("방ID 옵저버 가져오기 성공")
                    self.handleRoomEvent(observeData)
                    
                case .failure(_):
                    print("방ID 옵저버 가져오기 실패")
                }
            }
        }
    }
    
    private func observeRoomsData(_ toUpdate: [String: Rooms]) {
        let roomIDs: [String] = Array(toUpdate.keys)
        
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.setRoomsObserver(roomIDs: roomIDs) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let event):
                    print("방 데이터 옵저버 가져오기 성공")
                    self.handleRoomEvent(event)
                case .failure(_):
                    print("방 데이터 옵저버 가져오기 실패")
                    break
                }
            }
        }
    }
    
    
    // MARK: - 업데이트 분기처리
    private func handleRoomEvent(_ event: (DataChangeEvent<[String: Rooms]>)) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedRoomsEvent(toUpdate)
            
            // 데이터 초기 로드
        case .initialLoad(let roomDict):
            print("\(#function) ----- init")
            self.handleInitialLoadRoomsEvent(roomDict)
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedRoomsEvent(toAdd)
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            self.handleRemovedRoomsEvent(roomID)
        }
    }
    
    
    // MARK: - 업데이트
    private func handleUpdatedRoomsEvent(_ toUpdate: [String: [String: Any]]) {
        // 리턴할 인덱스패스
        var updatedIndexPaths = [IndexPath]()
        
        for (roomID, changedData) in toUpdate {
            if let indexPath = self.roomIDToIndexPathMap[roomID] {
                // 뷰모델에 바뀐 user데이터 저장
                self.roomsCellViewModels[indexPath.row].updateRoomData(changedData)
                updatedIndexPaths.append(indexPath)
            }
        }
        // 노티피케이션 post
        self.postNotification(name: .roomDataChanged,
                              eventType: .updated,
                              indexPath: updatedIndexPaths)
    }
    
    // MARK: - 초기 설정
    private func handleInitialLoadRoomsEvent(_ roomDict: [String: Rooms]) {
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
        // 방 데이터에 대한 옵저버 설정
        self.observeRoomsData(roomDict)
        // 데코 데이터 업데이트
        self.fetchDecoration(roomDict: roomDict) {
            // 노티피케이션 post
            self.postNotification(name: .roomDataChanged,
                                  eventType: .initialLoad,
                                  indexPath: addedIndexPaths)
        }
    }
    
    // MARK: - 생성
    private func handleAddedRoomsEvent(_ toAdd: [String: Rooms]) {
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
        // 방 데이터에 대한 옵저버 설정
        self.observeRoomsData(toAdd)
        // 데코 데이터 업데이트
        self.fetchDecoration(roomDict: toAdd) {
            // 노티피케이션 post
            self.postNotification(name: .roomDataChanged,
                                  eventType: .added,
                                  indexPath: addedIndexPaths)
        }
    }
    
    // MARK: - 삭제
    private func handleRemovedRoomsEvent(_ roomID: String) {
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
        // 노티피케이션 post
        self.postNotification(name: .roomDataChanged,
                              eventType: .removed,
                              indexPath: removedIndexPaths)
    }
}
