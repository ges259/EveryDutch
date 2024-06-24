//
//  RoomDataManager+ReceiptData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/12/24.
//

import Foundation

//extension RoomDataManager {
//    
//    // MARK: - 데이터 fetch
//    func loadRoomReceipt(completion: @escaping Typealias.VoidCompletion) {
//        // 버전 ID 가져오기
//        guard let versionID = self.getCurrentVersion else {
//            completion(.failure(.readError))
//            return
//        }
//        DispatchQueue.global(qos: .utility).async {
//            self.receiptAPI.readRoomReceipts(versionID: versionID) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let initialLoad):
//                    self.handleReceiptEvent(initialLoad)
//                    if !self.roomReceiptInitialLoad {
//                        self.roomReceiptInitialLoad = true
//                        completion(.success(()))
//                    }
//                    print("영수증 가져오기 성공")
//                case .failure(let error):
//                    completion(.failure(error))
//                    print("영수증 가져오기 실패")
//                }
//            }
//        }
//    }
//    
//    /// 데이터를 추가적으로 가져오는 코드
//    func loadMoreRoomReceipt() {
//        guard self.hasMoreRoomReceiptData,
//              let versionID = self.getCurrentVersion 
//        else { return }
//        
//        DispatchQueue.global(qos: .utility).async {
//            self.receiptAPI.loadMoreRoomReceipts(versionID: versionID) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let loadData):
//                    print("영수증 추가적으로 가져오기 성공")
//                    self.handleAddedMoreReceiptData(loadData)
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        switch error {
//                        case .noMoreData:
//                            self.hasMoreRoomReceiptData = false
//                            break
//                        default:
//                            break
//                        }
//                        print("영수증 추가적으로 가져오기 실패")
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - 업데이트 분기처리
//    private func handleReceiptEvent(_ event: DataChangeEvent<[ReceiptTuple]>) {
//        switch event {
//        case .updated(let toUpdate):
//            print("\(#function) ----- update")
//            self.handleUpdatedReceiptEvent(toUpdate)
//            
//        case .initialLoad(let userDict):
//            print("\(#function) ----- init")
//            self.handleInitialLoadReceiptEvent(userDict)
//        case .added(let toAdd):
//            print("\(#function) ----- add")
//            self.handleAddedReceiptEvent(toAdd)
//            
//        case .removed(let roomID):
//            print("\(#function) ----- remove")
//            self.handleRemovedReceiptEvent(roomID)
//        }
//    }
//    
//    // MARK: - 업데이트
//    private func handleUpdatedReceiptEvent(_ toUpdate: [String: [String: Any]]) {
//        if toUpdate.isEmpty { return }
//        
//        // 리턴할 인덱스패스
//        var updatedIndexPaths = [IndexPath]()
//        
//        for (receiptID, changedData) in toUpdate {
//            if let indexPath = self.receiptIDToIndexPathMap[receiptID] {
//                // 뷰모델에 바뀐 데이터 저장
//                self.roomReceiptCellViewModels[indexPath.row].updateReceipt(changedData)
//                updatedIndexPaths.append(indexPath)
//            }
//        }
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .updated, updatedIndexPaths)
//    }
//    
//    // MARK: - 초기 설정
//    private func handleInitialLoadReceiptEvent(_ userDict: [ReceiptTuple]) {
//        if userDict.isEmpty { return }
//        
//        // 리턴할 인덱스패스
//        var addedIndexPaths = [IndexPath]()
//        
//        // 모든 데이터 추가
//        for (index, (receiptID, room)) in userDict.enumerated() {
//            // 인덱스 패스 생성
//            let indexPath = IndexPath(row: index, section: 0)
//            // 뷰모델 생성
//            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
//            // 뷰모델 저장
//            self.roomReceiptCellViewModels.append(viewModel)
//            // 인덱스패스 저장
//            self.receiptIDToIndexPathMap[receiptID] = indexPath
//            addedIndexPaths.append(indexPath)
//        }
//        
//        print("addedIndexPaths 개수 ----- \(addedIndexPaths.count)")
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .initialLoad, addedIndexPaths)
//    }
//    
//    // MARK: - 생성
//    /// (맨 앞에 추가)
//    private func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple]) {
//        // 리턴할 인덱스패스
//        var addedIndexPaths = [IndexPath]()
//        
//        for (receiptID, room) in toAdd {
//            // 중복 추가 방지
//            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
//            
//            // 인덱스패스 생성 (항상 0번째 위치에 추가)
//            let indexPath = IndexPath(row: 0, section: 0)
//            
//            // 뷰모델 생성
//            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
//            
//            // 뷰모델 저장 (항상 리스트의 맨 앞에 추가)
//            self.roomReceiptCellViewModels.insert(viewModel, at: 0)
//            
//            // 인덱스패스 업데이트
//            self.receiptIDToIndexPathMap[receiptID] = indexPath
//            addedIndexPaths.append(indexPath)
//        }
//        
//        // 모든 인덱스패스 재설정
//        self.updateIndexPaths(0)
//        
//        // 변경 사항을 알리는 알림 전송
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
//    }
//
//
//    /// 데이터를 추가적으로 가져올 때 (맨 뒤에 추가)
//    private func handleAddedMoreReceiptData(_ toAdd: [ReceiptTuple]) {
//        print(#function)
//        if toAdd.isEmpty {
//            self.hasMoreRoomReceiptData = false
//            return
//        }
//        // 리턴할 인덱스패스
//        var addedIndexPaths = [IndexPath]()
//        
//        for (receiptID, room) in toAdd {
//            // 중복 추가 방지
//            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
//            // 인덱스패스 생성
//            let indexPath = IndexPath(row: self.roomReceiptCellViewModels.count, section: 0)
//            
//            // 뷰모델 생성
//            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
//            // 뷰모델 저장
//            self.roomReceiptCellViewModels.append(viewModel)
//            // 인덱스패스 업데이트
//            self.receiptIDToIndexPathMap[receiptID] = indexPath
//            addedIndexPaths.append(indexPath)
//        }
//        // 변경 사항을 알리는 알림 전송
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
//    }
//    
//    // MARK: - 삭제
//    private func handleRemovedReceiptEvent(_ receiptID: String) {
//        // 리턴할 인덱스패스
//        var removedIndexPaths = [IndexPath]()
//        
//        if let indexPath = self.receiptIDToIndexPathMap[receiptID] {
//            // 뷰모델 삭제
//            self.roomReceiptCellViewModels.remove(at: indexPath.row)
//            // 인덱스패스 삭제
//            self.receiptIDToIndexPathMap.removeValue(forKey: receiptID)
//            // 데이터 삭제
//            removedIndexPaths.append(indexPath)
//            // 삭제 후 인덱스 재정렬
//            self.updateIndexPaths(indexPath.row)
//        }
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .removed, removedIndexPaths)
//    }
//    
//    private func updateIndexPaths(_ index: Int) {
//        for i in index..<self.roomReceiptCellViewModels.count {
//            // 해당 인덱스의 뷰모델에 있는 receiptID를 가져옴
//            let receiptID = self.roomReceiptCellViewModels[i].getReceiptID
//            // 인덱스 재정렬
//            self.receiptIDToIndexPathMap[receiptID] = IndexPath(row: i, section: 0)
//        }
//    }
//}




















// MARK: - Receipt Section
struct ReceiptSection {
    var date: String
    var receipts: [ReceiptTableViewCellVMProtocol]
}

extension RoomDataManager {
    // MARK: - 데이터 fetch
    func loadRoomReceipt(completion: @escaping Typealias.VoidCompletion) {
        guard let versionID = self.getCurrentVersion else {
            completion(.failure(.readError))
            return
        }
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.readRoomReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    self.handleReceiptEvent(initialLoad)
                    if !self.roomReceiptInitialLoad {
                        self.roomReceiptInitialLoad = true
                        completion(.success(()))
                    }
                    print("영수증 가져오기 성공")
                case .failure(let error):
                    completion(.failure(error))
                    print("영수증 가져오기 실패")
                }
            }
        }
    }
    
    func loadMoreRoomReceipt() {
        guard self.hasMoreRoomReceiptData,
              let versionID = self.getCurrentVersion
        else { return }
        
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.loadMoreRoomReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let loadData):
                    print("영수증 추가적으로 가져오기 성공")
                    self.handleAddedMoreReceiptData(loadData)
                case .failure(let error):
                    DispatchQueue.main.async {
                        switch error {
                        case .noMoreData:
                            self.hasMoreRoomReceiptData = false
                            break
                        default:
                            break
                        }
                        print("영수증 추가적으로 가져오기 실패")
                    }
                }
            }
        }
    }
    
    private func handleReceiptEvent(_ event: DataChangeEvent<[ReceiptTuple]>) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedReceiptEvent(toUpdate)
            
        case .initialLoad(let userDict):
            print("\(#function) ----- init")
            self.handleInitialLoadReceiptEvent(userDict)
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedReceiptEvent(toAdd)
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            self.handleRemovedReceiptEvent(roomID)
        }
    }
    
    private func handleUpdatedReceiptEvent(_ toUpdate: [String: [String: Any]]) {
        if toUpdate.isEmpty { return }
        
        var updatedIndexPaths = [IndexPath]()
        
        for (receiptID, changedData) in toUpdate {
            if let indexPath = self.receiptIDToIndexPathMap[receiptID] {
                self.receiptSections[indexPath.section].receipts[indexPath.row].updateReceipt(changedData)
                updatedIndexPaths.append(indexPath)
            }
        }
        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .updated, updatedIndexPaths)
    }
    
    private func handleInitialLoadReceiptEvent(_ userDict: [ReceiptTuple]) {
        if userDict.isEmpty { return }
        
        var addedIndexPaths = [IndexPath]()
        
        let groupedReceipts = Dictionary(grouping: userDict) { (tuple) -> String in
            return tuple.1.date
        }
        
        var sections = [ReceiptSection]()
        
        for (date, receipts) in groupedReceipts {
            var cellViewModels = [ReceiptTableViewCellVMProtocol]()
            for (index, (receiptID, receipt)) in receipts.enumerated() {
                let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
                cellViewModels.append(viewModel)
                let indexPath = IndexPath(row: index, section: sections.count)
                self.receiptIDToIndexPathMap[receiptID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            let section = ReceiptSection(date: date, receipts: cellViewModels)
            sections.append(section)
        }
        
        self.receiptSections = sections
        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .initialLoad, addedIndexPaths)
    }
    
    private func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple]) {
        var addedIndexPaths = [IndexPath]()
        
        for (receiptID, receipt) in toAdd {
            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
            
            let date = receipt.date
            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
            
            if sectionIndex == nil {
                let newSection = ReceiptSection(date: date, receipts: [])
                self.receiptSections.insert(newSection, at: 0)
                sectionIndex = 0
            }
            
            let indexPath = IndexPath(row: 0, section: sectionIndex!)
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
            self.receiptSections[sectionIndex!].receipts.insert(viewModel, at: 0)
            self.receiptIDToIndexPathMap[receiptID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        
        self.updateIndexPaths(0)
        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
    }
    
    private func handleAddedMoreReceiptData(_ toAdd: [ReceiptTuple]) {
        print(#function)
        if toAdd.isEmpty {
            self.hasMoreRoomReceiptData = false
            return
        }
        
        var addedIndexPaths = [IndexPath]()
        
        for (receiptID, receipt) in toAdd {
            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
            
            let date = receipt.date
            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
            
            if sectionIndex == nil {
                let newSection = ReceiptSection(date: date, receipts: [])
                self.receiptSections.append(newSection)
                sectionIndex = self.receiptSections.count - 1
            }
            
            let indexPath = IndexPath(row: self.receiptSections[sectionIndex!].receipts.count, section: sectionIndex!)
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
            self.receiptSections[sectionIndex!].receipts.append(viewModel)
            self.receiptIDToIndexPathMap[receiptID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        
        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
    }
    
    private func handleRemovedReceiptEvent(_ receiptID: String) {
        var removedIndexPaths = [IndexPath]()
        
        if let indexPath = self.receiptIDToIndexPathMap[receiptID] {
            self.receiptSections[indexPath.section].receipts.remove(at: indexPath.row)
            self.receiptIDToIndexPathMap.removeValue(forKey: receiptID)
            removedIndexPaths.append(indexPath)
            self.updateIndexPaths(indexPath.row)
        }
        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .removed, removedIndexPaths)
    }
    
    private func updateIndexPaths(_ index: Int) {
        for sectionIndex in 0..<self.receiptSections.count {
            for rowIndex in 0..<self.receiptSections[sectionIndex].receipts.count {
                let receiptID = self.receiptSections[sectionIndex].receipts[rowIndex].getReceiptID
                self.receiptIDToIndexPathMap[receiptID] = IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
    }
}
