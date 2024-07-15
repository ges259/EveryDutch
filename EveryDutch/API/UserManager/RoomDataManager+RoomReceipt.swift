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
            self.receiptAPI.observeRoomReceipts(
                versionID: versionID,
                isInitialLoad: true
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    self.handleReceiptEvent(initialLoad)
                    print("방 영수증 가져오기 성공")
                case .failure(let error):
                    print("방 영수증 가져오기 실패")
                    self.roomDebouncer.triggerErrorDebounce(error)
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
            self.receiptAPI.observeRoomReceipts(
                versionID: versionID,
                isInitialLoad: false
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let loadData):
                    self.handleReceiptEvent(loadData)
                    print("방 영수증 추가적으로 가져오기 성공")
                case .failure(_):
                    self.roomDebouncer.triggerErrorDebounce(.noMoreData)
                    print("방 영수증 추가적으로 가져오기 실패")
                }
            }
        }
    }
    
    
    
    // MARK: - 분기처리
    private func handleReceiptEvent(_ event: DataChangeEvent<[ReceiptTuple]>) {
        switch event {
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.receiptDebounce(toAdd)
            
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedReceiptEvent(toUpdate)
            
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
    
    
    
    /// 디바운스를 설정하는 메서드
    // typealias ReceiptTuple = (receiptID: String, receipt: Receipt)
    private func receiptDebounce(_ toAdd: [ReceiptTuple]) {
        print("\(#function) ----- 1")
        // 비어있지 않다면,
        guard !toAdd.isEmpty else { return }
        // 현재 작업 취소
        self.receiptWorkItem?.cancel()
        
        // 인덱스 패스를 서로 합치기
        self.receiptTupleArray.append(contentsOf: toAdd)
        
        
        // 일정 시간이 지난 후, 동작할 행동 설정
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.handleAddedReceiptEvent(self.receiptTupleArray,
                                         sections: &self.receiptSections,
                                         debouncer: &self.receiptDebouncer)
            // 초기화
            self.receiptTupleArray = []
            self.receiptWorkItem = nil
        }
        // 행동 저장
        self.receiptWorkItem = newWorkItem
        
        
        // 디바운스 설정
        self.receiptQueue.asyncAfter(deadline: .now() + 0.1,
                              execute: newWorkItem)
    }
    
    
    // MARK: - 추가
    func handleAddedReceiptEvent(
        _ toAdd: [ReceiptTuple],
        sections: inout [ReceiptSection],
        debouncer: inout Debouncer
    ) {
        print("\(#function) ----- 1")
        print("toAdd 개수 ---- \(toAdd.count)")
        
        // 추가할 섹션의 IndexPath 저장
        var sectionsToInsert = IndexSet()
        // 추가할 행의 IndexPath 저장
        var rowsToInsert = [IndexPath]()
        
        for (receiptID, receipt) in toAdd.reversed() {
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
            // 행 추가
            let rowIndex = sections[sectionIndex!].receipts.count
            rowsToInsert.append(IndexPath(row: rowIndex, 
                                          section: sectionIndex!))
            print("rowIndex - 행추가 : \(rowIndex)")
            print("rowsToInsert - 현재 인덱스패스 : \(rowsToInsert)")
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
            debouncer.triggerDebounceWithIndexPaths(
                eventType: .sectionInsert,
                sectionsToInsert.map { IndexPath(row: 0, section: $0) }
            )
        }
        // 행이 추가된 경우, sectionReload 이벤트 트리거
        if !rowsToInsert.isEmpty {
            debouncer.triggerDebounceWithIndexPaths(
                eventType: .added,
                rowsToInsert
            )
        }
        print("sectionsToInsert 개수 ----- \(sectionsToInsert)")
        print("rowsToInsert 개수 ----- \(rowsToInsert)")
    }
}
