//
//  RoomDataManager+RoomData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/11/24.
//

import Foundation

extension RoomDataManager {
    
    // MARK: - 데이터 fetch
    func loadRooms() {
        // 만약 User_RoomsID에 데이터가 없더라도 SplashScreenVC에서 MainVC로 넘어가기 위해 일단 디바운싱을 트리거 해놓음
        self.triggerRoomDataDebouncing(eventType: .initialLoad, indexPaths: [], debounceInterval: 2)
        
        // 옵저버 설정
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.setUserRoomsIDObserver { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let observeData):
                    print("방ID 옵저버 가져오기 성공")
                    self.handleRoomEvent(observeData)
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("방ID 옵저버 가져오기 실패")
                        NotificationCenter.default.post(
                            name: .roomDataChanged,
                            object: nil,
                            userInfo: ["error": error])
                    }
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
        self.triggerRoomDataDebouncing(eventType: .updated, indexPaths: updatedIndexPaths)
    }
    
    // MARK: - 초기 설정
    private func handleInitialLoadRoomsEvent(_ roomDict: [String: Rooms]) {
        // 리턴할 인덱스패스
        var addedIndexPaths = [IndexPath]()
        // 모든 데이터 추가
        for (roomID, room) in roomDict {
            // 인덱스 패스 생성
            let indexPath = IndexPath(row: self.roomsCellViewModels.count, section: 0)
            // 뷰모델 생성
            let viewModel = MainCollectionViewCellVM(roomID: roomID,
                                                     room: room)
            // 뷰모델 저장
            self.roomsCellViewModels.append(viewModel)
            // 인덱스패스 저장
            self.roomIDToIndexPathMap[roomID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        // 데코 데이터 업데이트
        self.fetchDecoration(roomDict: roomDict) { [weak self] in
            guard let self = self else { return }
            // 노티피케이션 post
            self.triggerRoomDataDebouncing(eventType: .initialLoad, indexPaths: addedIndexPaths)
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
        // 데코 데이터 업데이트
        self.fetchDecoration(roomDict: toAdd) { [weak self] in
            guard let self = self else { return }
            // 노티피케이션 post
            self.triggerRoomDataDebouncing(eventType: .added, indexPaths: addedIndexPaths)
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
        self.triggerRoomDataDebouncing(eventType: .removed, indexPaths: removedIndexPaths)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Room데이터 디바운싱
    /// 디바운싱 시작
    func triggerRoomDataDebouncing(
        eventType: NotificationInfoString,
        indexPaths: [IndexPath],
        debounceInterval: CGFloat = 1)
    {
        // 기존에 스케줄된 작업이 있다면 취소
        self.roomDataDebounceWorkItem?.cancel()
        
        // 이벤트 타입에 따라 인덱스 패스를 저장
        self.addIndexPaths(eventType: eventType, indexPaths: indexPaths)
        
        // 새로운 작업 아이템 생성
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            // 데이터 업데이트 후 노티피케이션 전송
            self.postRoomDataChangedNotification()
        }
        
        // 작업 아이템을 예약
        self.roomDataDebounceWorkItem = workItem
        self.roomDataQueue.asyncAfter(
            deadline: .now() + debounceInterval,
            execute: workItem)
    }

    /// 인덱스 패스 추가 로직
    private func addIndexPaths(
        eventType: NotificationInfoString, 
        indexPaths: [IndexPath])
    {
        let notiName = eventType.notificationName
        
        // 이벤트 타입에 따라 인덱스 패스를 저장
        if self.changedRoomIndexPaths[notiName] == nil {
            self.changedRoomIndexPaths[notiName] = []
        }
        
        for indexPath in indexPaths {
            if let existingIndexPaths = self.changedRoomIndexPaths[notiName],
               !existingIndexPaths.contains(indexPath)
            {
                self.changedRoomIndexPaths[notiName]?.append(indexPath)
            }
        }
    }

    /// 노티피케이션 전송
    private func postRoomDataChangedNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // 비어있어도 notification 전송 (room데이터가 없을 수도 있기 때문)
            // 노티피케이션 전송
            NotificationCenter.default.post(
                name: .roomDataChanged,
                object: nil,
                userInfo: self.changedRoomIndexPaths
            )
            // post한 인덱스패스를 초기화 시킴
            self.changedRoomIndexPaths = [:]
        }
    }
}
