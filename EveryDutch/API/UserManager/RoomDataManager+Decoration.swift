//
//  RoomDataManager+Decoration.swift
//  EveryDutch
//
//  Created by 계은성 on 5/24/24.
//

import Foundation

// MARK: - RoomDataManager
extension RoomDataManager {
    func fetchDecoration(roomDict: [String : Rooms],
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

    private func handleUpdatedDecoEvent(_ toUpdate: [String: [String: Any]]) {
        
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
