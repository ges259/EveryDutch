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
    func loadRoomReceipt() {
        guard let versionID = self.getCurrentVersion else {
            return
        }
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.readRoomReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    self.handleReceiptEvent(initialLoad)
                    print("영수증 가져오기 성공")
                case .failure(let error):
                    print("영수증 가져오기 실패")
                }
            }
        }
    }
    
    
    // MARK: - 데이터 추가적으로 가져오기
    func loadMoreRoomReceipt() {
        print(#function)
        guard let versionID = self.getCurrentVersion
        else { return }
        
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.loadMoreRoomReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let loadData):
                    print("영수증 추가적으로 가져오기 성공")
                    self.handleAddedReceiptEvent(loadData, sections: &self.receiptSections)
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        switch error {
                        case .noMoreData:
                            
                            
                            break
                        default:
                            break
                        }
                        self.receiptDebouncer.triggerErrorDebounce(.hasNoAPIData)
                        print("영수증 추가적으로 가져오기 실패")
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - 분기처리
    private func handleReceiptEvent(_ event: DataChangeEvent<[ReceiptTuple]>) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedReceiptEvent(toUpdate)
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedReceiptEvent(toAdd, sections: &self.receiptSections)
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            self.handleRemovedReceiptEvent(roomID)
            
            
        case .initialLoad(_):
            print("\(#function) ----- init")
            break
        }
    }
    
    
    
    // MARK: - 업데이트
    private func handleUpdatedReceiptEvent(_ toUpdate: [String: [String: Any]]) {
        if toUpdate.isEmpty { return }
        
        var updatedIndexPaths = [IndexPath]()
        
        for (receiptID, changedData) in toUpdate {
            for sectionIndex in 0..<self.receiptSections.count {
                if let rowIndex = self.receiptSections[sectionIndex].receipts.firstIndex(where: { $0.getReceiptID == receiptID }) {
                    self.receiptSections[sectionIndex]
                        .receipts[rowIndex]
                        .updateReceipt(receiptID: receiptID, changedData)
                    
                    updatedIndexPaths.append(IndexPath(row: rowIndex, section: sectionIndex))
                    break
                }
            }
        }
        
        self.receiptDebouncer.triggerDebounceWithIndexPaths(
            eventType: .updated,
            updatedIndexPaths
        )
    }
    
    
    
    // MARK: - 삭제
    private func handleRemovedReceiptEvent(_ receiptID: String) {
        var removedIndexPaths = [IndexPath]()
        var sectionsToRemove = [Int]()
        
        for sectionIndex in 0..<self.receiptSections.count {
            if let rowIndex = self.receiptSections[sectionIndex].receipts.firstIndex(where: { $0.getReceiptID == receiptID }) {
                // 영수증을 해당 섹션에서 제거
                self.receiptSections[sectionIndex].receipts.remove(at: rowIndex)
                removedIndexPaths.append(IndexPath(row: rowIndex, section: sectionIndex))
                
                // 섹션이 비어있다면 섹션 자체를 제거
                if self.receiptSections[sectionIndex].receipts.isEmpty {
                    self.receiptSections.remove(at: sectionIndex)
                    sectionsToRemove.append(sectionIndex)
                }
                break
            }
        }
        
        // 섹션들을 날짜 순서대로 정렬
        self.receiptSections.sort { $0.date > $1.date }
        
        // debounce를 사용하여 테이블뷰 업데이트
        if !sectionsToRemove.isEmpty {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .sectionRemoved,
                sectionsToRemove.map { IndexPath(row: 0, section: $0) }
            )
        } else {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .removed,
                removedIndexPaths
            )
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - 추가
    func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple], sections: inout [ReceiptSection]) {

        // 추가할 섹션의 IndexPath 저장
        var sectionsToInsert = IndexSet()
        // 추가할 행의 IndexPath 저장
        var rowsToInsert = [IndexPath]()
        
        for (receiptID, receipt) in toAdd {
            // 이미 존재하는 영수증은 건너뜀
            if sections.contains(
                where: { $0.receipts.contains { $0.getReceiptID == receiptID } }
            ) { continue }
            
            // 영수증의 날짜를 가져옴
            let date = receipt.date
            // 현재 섹션들 중에서 해당 날짜(date)를 가진 섹션의 인덱스를 찾음
            var sectionIndex = sections.firstIndex { $0.date == date }
            
            // 해당 섹션이 없는 경우
            if sectionIndex == nil {
                // 섹션이 없는 경우 새 섹션을 추가
                let newSection = ReceiptSection(date: date, receipts: [])
                
                // 날짜를 비교하여 적절한 위치에 삽입
                if let insertIndex = sections.firstIndex(where: { $0.date < date }) {
                    sections.insert(newSection, at: insertIndex)
                    sectionIndex = insertIndex
                } else {
                    sections.append(newSection)
                    sectionIndex = sections.count - 1
                }
                // 새 섹션의 인덱스를 sectionsToInsert에 추가
                sectionsToInsert.insert(sectionIndex!)
            }
            // 해당 섹션이 존재하는 경우, 행 추가
            let rowIndex = sections[sectionIndex!].receipts.count
            rowsToInsert.append(IndexPath(row: rowIndex, section: sectionIndex!))
            
            
            
            // 새 영수증의 ViewModel을 생성하고 섹션에 추가
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID,
                                                   receiptData: receipt)
            sections[sectionIndex!].receipts.append(viewModel)
        }

        // 섹션들을 날짜 순서대로 정렬
        sections.sort { $0.date > $1.date }

        // 섹션 내 영수증들을 시간 순서대로 정렬
        for sectionIndex in 0..<sections.count {
            sections[sectionIndex].receipts.sort { $0.getReceipt.time > $1.getReceipt.time }
        }
        
        // 새 섹션이 추가된 경우, sectionInsert 이벤트 트리거
        // debounce를 사용하여 테이블뷰 업데이트
        if !sectionsToInsert.isEmpty {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .sectionInsert,
                sectionsToInsert.map { IndexPath(row: 0, section: $0) }
            )
            print("____________________")
            print(#function)
            dump(sectionsToInsert)
            print("____________________")
        }
        // 행이 추가된 경우, sectionReload 이벤트 트리거
        if !rowsToInsert.isEmpty {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .added,
                rowsToInsert
            )
            print("____________________")
            print(#function)
            dump(rowsToInsert)
            print("____________________")
        }
    }
    
    
    
    
    
//    func handleAddedReceiptEvent(
//        _ toAdd: [ReceiptTuple],
//        sections: inout [ReceiptSection]
//    ) {
//        print("가져온 데이터의 수: \(toAdd.count)")
//        // -O1Iz9BkhNIdeLKJsTOd
//        
//        
//        // 추가할 섹션의 IndexPath 저장
//        var sectionsToInsert = IndexSet()
//        // 추가할 행의 IndexPath 저장
//        var rowsToInsert = [IndexPath]()
//        
//        for (receiptID, receipt) in toAdd {
//            // 이미 존재하는 영수증은 건너뜀
//            if sections.contains(where: { $0.receipts.contains { $0.getReceiptID == receiptID } }) {
//                continue
//            }
//            
//            // 영수증의 날짜를 가져옴
//            let date = receipt.date
//            // 현재 섹션들 중에서 해당 날짜(date)를 가진 섹션의 인덱스를 찾음
//            var sectionIndex = sections.firstIndex { $0.date == date }
//            
//            // 해당 섹션이 없는 경우
//            if sectionIndex == nil {
//                print("해당 섹션 없음")
//                // 섹션이 없는 경우 새 섹션을 추가
//                let newSection = ReceiptSection(date: date, receipts: [])
//                
//                // 날짜를 비교하여 적절한 위치에 삽입
//                if let insertIndex = sections.firstIndex(where: { $0.date < date }) {
//                    sections.insert(newSection, at: insertIndex)
//                    sectionIndex = insertIndex
//                    print("--1")
//                    print("sections 개수 ----- \(sections.count)")
//                    print("sectionIndex ----- \(sectionIndex)")
//                } else {
//                    print("--2")
//                    
//                    sections.append(newSection)
//                    sectionIndex = sections.count - 1
//                }
//                // 새 섹션의 인덱스를 sectionsToInsert에 추가
//                sectionsToInsert.insert(sectionIndex!)
//            } else {
//                print("해당 섹션 있음")
//            }
//            
//            // 해당 섹션이 존재하는 경우, 행 추가
//            let rowIndex = sections[sectionIndex!].receipts.count
//            rowsToInsert.append(IndexPath(row: rowIndex, section: sectionIndex!))
//            
//            // 새 영수증의 ViewModel을 생성하고 섹션에 추가
//            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
//            sections[sectionIndex!].receipts.append(viewModel)
//            
//            print("_______________________")
//            print("_______________________")
//            print("_______________________")
//            dump(sections)
//            print("_______________________")
//            print("_______________________")
//            print("_______________________")
//        }
//        
//        // 섹션들을 날짜 순서대로 정렬
//        sections.sort { $0.date > $1.date }
//
//        // 섹션 내 영수증들을 시간 순서대로 정렬
//        for sectionIndex in 0..<sections.count {
//            sections[sectionIndex].receipts.sort { $0.getReceipt.time > $1.getReceipt.time }
//        }
//        
//        // 섹션과 행을 모두 추가하는 이벤트 트리거
//        var allIndexPathsToInsert = [IndexPath]()
//        
//        if !sectionsToInsert.isEmpty {
//            for section in sectionsToInsert {
//                allIndexPathsToInsert.append(IndexPath(row: 0, section: section))
//            }
//        }
//        
//        allIndexPathsToInsert.append(contentsOf: rowsToInsert)
//        
//        if !allIndexPathsToInsert.isEmpty {
//            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, allIndexPathsToInsert)
//            print("____________________")
//            print(#function)
//            
//            print("____________________")
//        }
//    }
    
    
    
}
