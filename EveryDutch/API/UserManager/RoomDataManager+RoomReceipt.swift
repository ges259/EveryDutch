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
        
        self.receiptDebouncer.initialDebounce(1)
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
                    print("\(#function) ----- observe ----- \(initialLoad)")
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
    
    
    
    
    
    
    
    
    // MARK: - 삭제
    private func handleRemovedReceiptEvent(_ receiptID: String) {
        
        print("\(#function) ----- 1")
        var removedIndexPaths = [IndexPath]()
        var sectionsToRemove = [Int]()
        
        for sectionIndex in 0..<self.receiptSections.count {
            print("\(#function) ----- 2")
            if let rowIndex = self.receiptSections[safe: sectionIndex]?
                .receipts
                .firstIndex(where: { $0.getReceiptID == receiptID })
            {
                print("\(#function) ----- 3")
                // 영수증을 해당 섹션에서 제거
                self.receiptSections[sectionIndex]
                    .receipts
                    .remove(at: rowIndex)
                removedIndexPaths.append(IndexPath(row: rowIndex,
                                                   section: sectionIndex))
                
                // 섹션이 비어있다면 섹션 자체를 제거
                if self.receiptSections[sectionIndex]
                    .receipts
                    .isEmpty
                {
                    print("\(#function) ----- 4")
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
            print("\(#function) ----- 5")
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .sectionRemoved,
                sectionsToRemove.map { IndexPath(row: 0, section: $0) }
            )
        }
        
        if !removedIndexPaths.isEmpty {
            print("\(#function) ----- 6")
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .removed,
                removedIndexPaths
            )
        }
    }
    
    
    
    // MARK: - 추가
    func handleAddedReceiptEvent(
        _ toAdd: [ReceiptTuple],
        sections: inout [ReceiptSection],
        debouncer: inout Debouncer
    ) {
        print("\(#function) ----- toAdd 개수 ---- \(toAdd.count)")
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
        // 행이 추가된 경우, added 이벤트 트리거
        if !rowsToInsert.isEmpty {
            debouncer.triggerDebounceWithIndexPaths(
                eventType: .added,
                rowsToInsert
            )
        }
        print("sectionsToInsert 개수 ----- \(sectionsToInsert)")
        print("rowsToInsert 개수 ----- \(rowsToInsert)")
    }
    
    
    
    
    
    
    
    
    /// 디바운스를 설정하는 메서드
    // typealias ReceiptTuple = (receiptID: String, receipt: Receipt)
    private func receiptDebounce(_ toAdd: [ReceiptTuple]) {
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
    
}



// 1720450800 // 7/9
// 1721280576 // 7/18

extension RoomDataManager {
    
    
    
    // MARK: - 업데이트
    private func handleUpdatedReceiptEvent(_ toUpdate: [String: [String: Any]]) {
        
        print("\(#function) ----- \(toUpdate)")
        
        if toUpdate.isEmpty { return }
        
        var updatedIndexPaths = [IndexPath]()
        // 바뀐 데이터 for in
        for (receiptID, changedData) in toUpdate {
            //
            for sectionIndex in 0..<self.receiptSections.count {
                // 바뀐 영수증 찾기
                if let rowIndex = self.receiptSections[sectionIndex]
                    .receipts
                    .firstIndex(where: { $0.getReceiptID == receiptID })
                {
                    
                    // 영수증 업데이트하기 전에 현재 영수증의 '날짜' 가져오기
                    let currentDate = self.receiptSections[sectionIndex]
                        .receipts[rowIndex].receiptDate
                    
                    // 인덱스가 바뀌기 전에 영수증 업데이트
                    self.receiptSections[sectionIndex]
                        .receipts[rowIndex]
                        .updateReceipt(receiptID: receiptID, changedData)
                    
                    
                    
                    // 업데이트된 데이터의 '날짜'가져오기 (+ String으로 변환)
                    var updateDate = ""
                    // 4. DatabaseConstants.date가 있는 섹션으로 이동
                    if let newDate = changedData[DatabaseConstants.date] as? Int {
                        updateDate = Date.returnYearString(date: Date(timeIntervalSince1970: TimeInterval(newDate)))
                    }
                    
                    
                    print("\(#function) ----- currentDate ----- \(currentDate)")
                    print("\(#function) ----- updateDate ----- \(updateDate)")
                    if currentDate != updateDate {
                        // DatabaseConstants.date가 바뀐다면
                        self.handleMoveReceiptEvent(
                            receiptID: receiptID,
                            changedData: changedData,
                            oldSectionIndex: sectionIndex,
                            oldRowIndex: rowIndex
                        )
                    } else {
                        // 바뀐 데이터 저장
                        updatedIndexPaths.append(
                            IndexPath(row: rowIndex,
                                      section: sectionIndex)
                        )
                        
                    }
                    break
                }
            }
        }
        if !updatedIndexPaths.isEmpty {
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .updated,
                updatedIndexPaths
            )
        }
    }
    
    // MARK: - 이동
    private func handleMoveReceiptEvent(
        receiptID: String,
        changedData: [String: Any],
        oldSectionIndex: Int,
        oldRowIndex: Int
    ) {
        var removedIndexPath: IndexPath?
        var newSectionIndex: Int?

        // 1. 해당 영수증을 찾고, 해당 영수증을 제거
        self.receiptSections[oldSectionIndex].receipts.remove(at: oldRowIndex)
        removedIndexPath = IndexPath(row: oldRowIndex, section: oldSectionIndex)

        // 2. 제거 시, 섹션에 행이 없다면, sectionRemoved 호출
        if self.receiptSections[oldSectionIndex].receipts.isEmpty {
            self.receiptSections.remove(at: oldSectionIndex)
            self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .sectionRemoved, [IndexPath(row: 0, section: oldSectionIndex)])
        }
        // 행 제거
        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .removed, [removedIndexPath!])
        
        
        // 4. DatabaseConstants.date가 있는 섹션으로 이동
        guard let newDate = changedData[DatabaseConstants.date] as? Int else { return }
        let newDateString = Date.returnYearString(date: Date(timeIntervalSince1970: TimeInterval(newDate)))

        
        
        if let index = self.receiptSections.firstIndex(where: { $0.date == newDateString }) {
            newSectionIndex = index
        } else {
            let newSection = ReceiptSection(date: newDateString, receipts: [])
            if let insertIndex = self.receiptSections.firstIndex(where: { $0.date < newDateString }) {
                self.receiptSections.insert(newSection, at: insertIndex)
                newSectionIndex = insertIndex
            } else {
                self.receiptSections.append(newSection)
                newSectionIndex = self.receiptSections.count - 1
            }
            self.receiptDebouncer.triggerDebounceWithIndexPaths(
                eventType: .sectionInsert,
                [IndexPath(row: 0, section: newSectionIndex!)]
            )
        }

        // 5. 추가 시, 섹션이 없다면, sectionInsert 호출
        let rowIndex = self.receiptSections[newSectionIndex!].receipts.count
        let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: Receipt(receiptID: receiptID, dictionary: changedData))
        self.receiptSections[newSectionIndex!].receipts.append(viewModel)
        
        self.receiptDebouncer.triggerDebounceWithIndexPaths(
            eventType: .added,
            [IndexPath(row: rowIndex, section: newSectionIndex!)]
        )
        print("업데이트된 섹션의 개수 : \(self.receiptSections.count)")
    }
}
