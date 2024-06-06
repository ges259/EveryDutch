//
//  RoomDataManager+Decoration.swift
//  EveryDutch
//
//  Created by 계은성 on 5/24/24.
//

import Foundation

extension RoomDataManager {
    // MARK: - 데이터 가져오기(옵저버)
    func fetchDecoration(roomDict: [String : Rooms],
                         completion: @escaping () -> Void) {
        
        self.roomDebouncer.addIndexPathsAndDebounce(eventType: .updated, [])
        let roomIDArray: [String] = Array(roomDict.keys)
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.observeDecorations(IDs: roomIDArray) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let event):
                    self.handleDecoEvent(event)
                    DispatchQueue.main.async {
                        completion()
                    }
                case .failure(let error):
                    print("error ----- \(#function) ----- \(error)")
                }
            }
        }
    }
    
    // MARK: - 이벤트 처리
    private func handleDecoEvent(_ event: DataChangeEvent<[String: Decoration?]>) {
        switch event {
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedDecoEvent(toAdd)
        case .removed(let removed):
            print("\(#function) ----- remove")
            self.handleRemovedDecoEvent(removed)
        default: 
            break
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
        self.roomDebouncer.addIndexPathsAndDebounce(eventType: .updated, addedIndexPaths)
    }
    
    // MARK: - 삭제
    private func handleRemovedDecoEvent(_ removed: String) {
        if let indexPath = self.roomIDToIndexPathMap[removed] {
            self.roomsCellViewModels[indexPath.row].removeDecoration()
            // 노티피케이션 post
            self.roomDebouncer.addIndexPathsAndDebounce(eventType: .removed, [indexPath])
        }
    }
}
