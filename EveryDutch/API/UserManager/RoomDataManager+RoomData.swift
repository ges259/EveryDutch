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
        self.roomsAPI.readRooms { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let initialLoad):
                DispatchQueue.main.async {
                    print("방 가져오기 성공")
                    self.updateRooms(initialLoad)
                    // Decoration가져오기
                    
                    // 옵저버 설정
                    self.observeRooms()
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
    
    // MARK: - 옵저버 설정
    private func observeRooms() {
        self.roomsAPI.setRoomObserver { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let observeData):
                print("방 옵저버 가져오기 성공")
                self.updateRooms(observeData)
                break
                
            case .failure(_):
                print("방 옵저버 가져오기 실패")
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
            
            for (roomID, changedData) in toUpdate {
                if let indexPath = self.roomIDToIndexPathMap[roomID] {
                    // 뷰모델에 바뀐 user데이터 저장
                    self.roomsCellViewModels[indexPath.row].updateRoomData(changedData)
                    updatedIndexPaths.append(indexPath)
                }
            }
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
            self.fetchDecoration(roomDict: roomDict) {
                print("fetchDecoration ----- \(#function)")
                self.postNotification(name: .roomDataChanged,
                                      eventType: .initialLoad,
                                      indexPath: addedIndexPaths)
            }
            
            
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
            
            self.fetchDecoration(roomDict: toAdd) {
                print("fetchDecoration ----- \(#function)")
                self.postNotification(name: .roomDataChanged,
                                      eventType: .added,
                                      indexPath: addedIndexPaths)
            }
            
            
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
            self.postNotification(name: .roomDataChanged,
                                  eventType: .removed,
                                  indexPath: removedIndexPaths)
        }
    }
}



// MARK: - RoomDataManager
extension RoomDataManager {
    private func fetchDecoration(roomDict: [String : Rooms],
                                 completion: @escaping () -> Void) {
        let roomIDArray: [String] = Array(roomDict.keys)
        
        self.roomsAPI.fetchAllDecorations(IDs: roomIDArray) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let event):
                self.updateDecoration(event)
                if case .initialLoad = event {
                    self.observeDecoration(roomIDArray: roomIDArray)
                    completion()
                }
            case .failure(_):
                print("\(self) ----- \(#function) ----- Error")
            }
        }
    }
    
    private func observeDecoration(roomIDArray: [String]) {
        self.roomsAPI.observeDecorations(IDs: roomIDArray) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let event):
                self.updateDecoration(event)
            case .failure(_):
                print("\(self) ----- \(#function) ----- Error")
            }
        }
    }
    
    private func updateDecoration(_ event: DataChangeEvent<[String: Decoration?]>) {
        switch event {
        case .updated(let toUpdate):
            self.handleUpdatedDecoEvent(toUpdate)
        case .initialLoad(let decorationDict):
            self.handleInitialLoadDecoEvent(decorationDict)
        case .added(let toAdd):
            self.handleAddedDecoEvent(toAdd)
        case .removed(let removed):
            self.handleRemovedDecoEvent(removed)
        }
    }

    private func handleUpdatedDecoEvent(_ toUpdate: [String: [String: Any]]) {
        print("\(#function) ----- update")
        var updatedIndexPaths = [IndexPath]()
        
        for (roomID, changedData) in toUpdate {
            if let indexPath = self.roomIDToIndexPathMap[roomID] {
                self.roomsCellViewModels[indexPath.row].updateDecoration(changedData)
                updatedIndexPaths.append(indexPath)
            }
        }
        self.decorationUpdateNotification(updatedIndexPaths)
    }

    private func handleInitialLoadDecoEvent(_ decorationDict: [String: Decoration?]) {
        for (roomID, changedData) in decorationDict {
            if let decoration = changedData,
               let indexPath = self.roomIDToIndexPathMap[roomID] {
                self.roomsCellViewModels[indexPath.row].setupDecoration(deco: decoration)
            }
        }
    }

    private func handleAddedDecoEvent(_ toAdd: [String: Decoration?]) {
        var addedIndexPaths = [IndexPath]()
        
        for (roomID, changedData) in toAdd {
            if let decoration = changedData,
               let indexPath = self.roomIDToIndexPathMap[roomID] {
                self.roomsCellViewModels[indexPath.row].setupDecoration(deco: decoration)
                addedIndexPaths.append(indexPath)
            }
        }
        self.decorationUpdateNotification(addedIndexPaths)
    }

    private func handleRemovedDecoEvent(_ removed: String) {
        if let indexPath = self.roomIDToIndexPathMap[removed] {
            self.roomsCellViewModels[indexPath.row].removeDecoration()
            self.decorationUpdateNotification([indexPath])
        }
    }
    
    private func decorationUpdateNotification(_ indexPath: [IndexPath]) {
        self.postNotification(name: .roomDataChanged,
                              eventType: .updated,
                              indexPath: indexPath)
    }
}
