//
//  RoomDataManager+ReceiptData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/12/24.
//

import Foundation

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
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedReceiptEvent(toAdd)
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            self.handleRemovedReceiptEvent(roomID)
            
            
        case .initialLoad(let userDict):
            print("\(#function) ----- init")
            break
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
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    private func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple]) {
//        print(#function)
//        var addedIndexPaths = [IndexPath]()
//        
//        for (receiptID, receipt) in toAdd {
//            // 이미 존재하는 영수증은 건너뜀
//            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
//            
//            // 영수증의 날짜를 가져옴
//            let date = receipt.date
//            // 현재 섹션들 중에서 해당 날짜(date)를 가진 섹션의 인덱스를 찾음
//            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
//            
//            // 해당 섹션이 없는 경우
//            if sectionIndex == nil {
//                // 섹션이 없는 경우 새 섹션을 추가
//                let newSection = ReceiptSection(date: date, receipts: [])
//                // 0번째 섹션에 추가
//                self.receiptSections.insert(newSection, at: 0)
//                // 섹션을 0으로 설정
//                sectionIndex = 0
//            }
//            
//            let indexPath = IndexPath(row: 0, section: sectionIndex!)
//            // 새 영수증의 ViewModel을 생성하고 섹션에 추가
//            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
//            self.receiptSections[sectionIndex!].receipts.insert(viewModel, at: 0)
//            self.receiptIDToIndexPathMap[receiptID] = indexPath
//            addedIndexPaths.append(indexPath)
//        }
//        
//        self.updateIndexPaths(0)
//        
//        if self.isFirst {
//            self.isFirst = false
//            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionReload, addedIndexPaths)
//        } else {
//            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionInsert, addedIndexPaths)
//        }
//        
//        // 처음에 화면에 들어설 때,
//            // 이미 section이 있음 -> reload
//        // 섹션이 없음
//            // insert
//        // 섹션이 있음
//            // reload
//    }
    
    private func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple]) {
        
        // 업데이트할 섹션의 IndexPath 저장
        var sectionsToReload = IndexSet()
        // 추가할 섹션의 IndexPath 저장
        var sectionsToInsert = IndexSet()
        // 추가할 행의 IndexPath 저장
        var rowsToInsert = [IndexPath]()
        
        for (receiptID, receipt) in toAdd {
            // 이미 존재하는 영수증은 건너뜀
            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
            
            // 영수증의 날짜를 가져옴
            let date = receipt.date
            // 현재 섹션들 중에서 해당 날짜(date)를 가진 섹션의 인덱스를 찾음
            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
            
            // 해당 섹션이 없는 경우
            if sectionIndex == nil {
                // 섹션이 없는 경우 새 섹션을 추가
                let newSection = ReceiptSection(date: date, receipts: [])
                self.receiptSections.insert(newSection, at: 0)
                sectionIndex = 0
                // 새 섹션의 인덱스를 sectionsToInsert에 추가
                sectionsToInsert.insert(sectionIndex!)
            } else {
                // 해당 섹션이 존재하는 경우, 해당 섹션에 새 영수증을 추가할 IndexPath를 rowsToInsert에 추가
                rowsToInsert.append(IndexPath(row: self.receiptSections[sectionIndex!].receipts.count, section: sectionIndex!))
            }
            
            // 새 영수증의 ViewModel을 생성하고 섹션에 추가
            let viewModel = ReceiptTableViewCellVM(
                receiptID: receiptID,
                receiptData: receipt)
            self.receiptSections[sectionIndex!].receipts.insert(viewModel, at: 0)
            // 영수증 ID와 IndexPath 매핑
            self.receiptIDToIndexPathMap[receiptID] = IndexPath(
                row: self.receiptSections[sectionIndex!].receipts.count - 1,
                section: sectionIndex!)
        }
        

        self.updateIndexPaths(0)
        
        if self.isFirst {
            self.isFirst = false
            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionReload, rowsToInsert)
        } else {
            // 새 섹션이 추가된 경우, sectionInsert 이벤트 트리거
            if !sectionsToInsert.isEmpty {
                self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionInsert, sectionsToInsert.map { IndexPath(row: 0, section: $0) })
            }
            // 행이 추가된 경우, sectionReload 이벤트 트리거
            if !rowsToInsert.isEmpty {
                self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionReload, rowsToInsert)
            }
        }
        
        // 처음에 화면에 들어설 때,
            // 이미 section이 있음 -> reload
        // 섹션이 없음
            // insert
        // 섹션이 있음
            // reload
    }
    
    
    
    
    private func handleAddedMoreReceiptData(_ toAdd: [ReceiptTuple]) {
        print(#function)
        
        // 추가할 데이터가 없는 경우, 더 이상 데이터가 없음을 표시하고 종료
        if toAdd.isEmpty {
            self.hasMoreRoomReceiptData = false
            return
        }
        
        // 업데이트할 섹션의 IndexPath 저장
        var sectionsToReload = IndexSet()
        // 추가할 섹션의 IndexPath 저장
        var sectionsToInsert = IndexSet()
        // 추가할 행의 IndexPath 저장
        var rowsToInsert = [IndexPath]()
        
        for (receiptID, receipt) in toAdd {
            // 이미 존재하는 영수증은 건너뜀
            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
            
            // 영수증의 날짜를 가져옴
            let date = receipt.date
            // 현재 섹션들 중에서 해당 날짜(date)를 가진 섹션의 인덱스를 찾음
            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
            
            // 해당 섹션이 없는 경우
            if sectionIndex == nil {
                // 섹션이 없는 경우 새 섹션을 추가
                let newSection = ReceiptSection(date: date, receipts: [])
                self.receiptSections.append(newSection)
                sectionIndex = self.receiptSections.count - 1
                // 새 섹션의 인덱스를 sectionsToInsert에 추가
                sectionsToInsert.insert(sectionIndex!)
            } else {
                // 해당 섹션이 존재하는 경우, 해당 섹션에 새 영수증을 추가할 IndexPath를 rowsToInsert에 추가
                rowsToInsert.append(IndexPath(row: self.receiptSections[sectionIndex!].receipts.count, section: sectionIndex!))
            }
            
            // 새 영수증의 ViewModel을 생성하고 섹션에 추가
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
            self.receiptSections[sectionIndex!].receipts.append(viewModel)
            // 영수증 ID와 IndexPath 매핑
            self.receiptIDToIndexPathMap[receiptID] = IndexPath(row: self.receiptSections[sectionIndex!].receipts.count - 1, section: sectionIndex!)
        }
        
        // 새 섹션이 추가된 경우, sectionInsert 이벤트 트리거
        if !sectionsToInsert.isEmpty {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionInsert, sectionsToInsert.map { IndexPath(row: 0, section: $0) })
        }
        // 행이 추가된 경우, sectionReload 이벤트 트리거
        if !rowsToInsert.isEmpty {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionReload, rowsToInsert)
        }
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
























//    private func handleInitialLoadReceiptEvent(_ userDict: [ReceiptTuple]) {
//        if userDict.isEmpty { return }
//
//        var addedIndexPaths = [IndexPath]()
//
//        let groupedReceipts = Dictionary(grouping: userDict) { (tuple) -> String in
//            return tuple.1.date
//        }
//
//        var sections = [ReceiptSection]()
//
//        for (date, receipts) in groupedReceipts {
//            var cellViewModels = [ReceiptTableViewCellVMProtocol]()
//            for (index, (receiptID, receipt)) in receipts.enumerated() {
//                let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
//                cellViewModels.append(viewModel)
//                let indexPath = IndexPath(row: index, section: sections.count)
//                self.receiptIDToIndexPathMap[receiptID] = indexPath
//                addedIndexPaths.append(indexPath)
//            }
//            let section = ReceiptSection(date: date, receipts: cellViewModels)
//            sections.append(section)
//        }
//
//        self.receiptSections = sections
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .initialLoad, addedIndexPaths)
//    }













//    private func handleAddedMoreReceiptData(_ toAdd: [ReceiptTuple]) {
//        print(#function)
//        if toAdd.isEmpty {
//            self.hasMoreRoomReceiptData = false
//            return
//        }
//
//        var addedIndexPaths = [IndexPath]()
//
//        for (receiptID, receipt) in toAdd {
//            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
//
//            let date = receipt.date
//            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
//
//            if sectionIndex == nil {
//                let newSection = ReceiptSection(date: date, receipts: [])
//                self.receiptSections.append(newSection)
//                sectionIndex = self.receiptSections.count - 1
//            }
//
//            let indexPath = IndexPath(row: self.receiptSections[sectionIndex!].receipts.count, section: sectionIndex!)
//            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
//            self.receiptSections[sectionIndex!].receipts.append(viewModel)
//            self.receiptIDToIndexPathMap[receiptID] = indexPath
//            addedIndexPaths.append(indexPath)
//        }
//
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
//    }
    
