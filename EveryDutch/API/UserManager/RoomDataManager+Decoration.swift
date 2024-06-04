//
//  RoomDataManager+Decoration.swift
//  EveryDutch
//
//  Created by 계은성 on 5/24/24.
//

import Foundation

extension RoomDataManager {
    // MARK: - 데이터 가져오기
    func fetchDecoration(roomDict: [String : Rooms],
                         completion: @escaping () -> Void) {
        let roomIDArray: [String] = Array(roomDict.keys)
        
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.fetchAllDecorations(IDs: roomIDArray) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let event):
                    print("fetchDecoration ----- \(#function)")
                    self.updateDecoration(event)
                    self.observeDecoration(roomIDArray: roomIDArray)
                    DispatchQueue.main.async {
                        completion()
                    }
                case .failure(let error):
                    print("error ----- \(#function) ----- \(error)")
                }
            }
        }
    }
    
    // MARK: - 옵저버 설정
    private func observeDecoration(roomIDArray: [String]) {
        
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.observeDecorations(IDs: roomIDArray) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let event):
                    self.updateDecoration(event)
                case .failure(let error):
                    print("error ----- \(#function) ----- \(error)")
                }
            }
        }
    }
    
    private func updateDecoration(_ event: DataChangeEvent<[String: Decoration?]>) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedDecoEvent(toUpdate)
        case .initialLoad(let decorationDict):
            print("\(#function) ----- init")
            self.handleInitialLoadDecoEvent(decorationDict)
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedDecoEvent(toAdd)
        case .removed(let removed):
            print("\(#function) ----- remove")
            self.handleRemovedDecoEvent(removed)
        }
    }
    
    // MARK: - 업데이트
    private func handleUpdatedDecoEvent(_ toUpdate: [String: [String: Any]]) {
        print(#function)
        var updatedIndexPaths = [IndexPath]()
        
        for (roomID, changedData) in toUpdate {
            if let indexPath = self.roomIDToIndexPathMap[roomID] {
                self.roomsCellViewModels[indexPath.row].updateDecoration(changedData)
                updatedIndexPaths.append(indexPath)
            }
        }
        // 노티피케이션 post
        self.decorationUpdateNotification(updatedIndexPaths)
    }
    
    // MARK: - 초기 설정
    private func handleInitialLoadDecoEvent(_ decorationDict: [String: Decoration?]) {
        print(#function)
        for (roomID, changedData) in decorationDict {
            if let decoration = changedData,
               let indexPath = self.roomIDToIndexPathMap[roomID] {
                self.roomsCellViewModels[indexPath.row].setupDecoration(deco: decoration)
            }
        }
    }
    
    // MARK: - 생성
    private func handleAddedDecoEvent(_ toAdd: [String: Decoration?]) {
        var addedIndexPaths = [IndexPath]()
        
        for (roomID, changedData) in toAdd {
            if let decoration = changedData,
               let indexPath = self.roomIDToIndexPathMap[roomID] {
                self.roomsCellViewModels[indexPath.row].setupDecoration(deco: decoration)
                addedIndexPaths.append(indexPath)
            }
        }
        // 노티피케이션 post
        self.decorationUpdateNotification(addedIndexPaths)
    }
    
    // MARK: - 삭제
    private func handleRemovedDecoEvent(_ removed: String) {
        if let indexPath = self.roomIDToIndexPathMap[removed] {
            self.roomsCellViewModels[indexPath.row].removeDecoration()
            // 노티피케이션 post
            self.decorationUpdateNotification([indexPath])
        }
    }
    
    // MARK: - 노티피케이션
    private func decorationUpdateNotification(_ indexPath: [IndexPath]) {
        DispatchQueue.main.async {
            self.postNotification(name: .roomDataChanged,
                                  eventType: .updated,
                                  indexPath: indexPath)
        }
    }
}
