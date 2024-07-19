//
//  ReceiptTableViewViewModel.swift
//  EveryDutch
//
//  Created by 계은성 on 6/28/24.
//

import UIKit

final class ReceiptTableViewVM: ReceiptTableViewVMProtocol {
    
    // MARK: - 모델
    private var _receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    private var _receiptSearchModeDataManager: IndexPathDataManager<User> = IndexPathDataManager()
    private let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 플래그
    private let _isSearchMode: Bool
    private var _hasNoMoreData: Bool = false
    
    
    
    // MARK: - 라이프사이클
    init (roomDataManager: RoomDataManagerProtocol,
          isSearchMode: Bool
    ) {
        print("searchMode - init : \(isSearchMode)")
        self.roomDataManager = roomDataManager
        self._isSearchMode = isSearchMode
    }
}






extension ReceiptTableViewVM {
    // MARK: - 플래그 변경
    func hasNoMoreDataSetTrue() {
        print(#function)
        self._hasNoMoreData = true
    }
    
    // MARK: - 데이터 리턴
    var isSearchMode: Bool {
        return self._isSearchMode
    }
    var hasNoMoreData: Bool {
        return self._hasNoMoreData
    }
    
    var haederSectionBackgroundColor: UIColor {
        return self._isSearchMode
        ? UIColor.normal_white
        : UIColor.deep_Blue
    }
}








// MARK: - 인덱스패스
extension ReceiptTableViewVM {
    var isNotificationError: ErrorEnum? {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.error
        : self._receiptDataManager.error
    }
    
    // 영수증 데이터 인덱스패스
    func receiptDataChanged(_ userInfo: [String: Any]) {
        self._receiptDataManager.dataChanged(userInfo)
    }
    func searchDataChanged(_ userInfo: [String: Any]) {
        self._receiptSearchModeDataManager.dataChanged(userInfo)
    }
    
    
    func getPendingReceiptIndexPaths() -> [(key: String, indexPaths: [IndexPath])] {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.getPendingIndexPaths()
        : self._receiptDataManager.getPendingIndexPaths()
    }
    
    func resetPendingReceiptIndexPaths() {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.resetIndexPaths()
        : self._receiptDataManager.resetIndexPaths()
    }
}










// MARK: - 테이블뷰
extension ReceiptTableViewVM {
    /// 섹션의 타이틀(날짜)를 반환
    func getReceiptSectionDate(section: Int) -> String? {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceiptSectionDate(section: section)
        : self.roomDataManager.getRoomReceiptSectionDate(section: section)
    }
    
    /// 섹션의 개수
    var numOfSections: Int {
        return self._isSearchMode
        ? self.roomDataManager.getNumOfUserReceiptsSection
        : self.roomDataManager.getNumOfRoomReceiptsSection
    }
    
    /// 영수증 개수
    func numOfRows(in section: Int) -> Int? {
        return self._isSearchMode
        ? self.roomDataManager.getNumOfUserReceipts(section: section)
        : self.roomDataManager.getNumOfRoomReceipts(section: section)
    }
    
    /// 영수증 셀의 뷰모델 반환
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol? {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceiptViewModel(indexPath: indexPath)
        : self.roomDataManager.getRoomReceiptViewModel(indexPath: indexPath)
    }
    
    /// 셀 선택 시, 해당 셀의 영수증 반환
    func getReceipt(at indexPath: IndexPath) -> Receipt? {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceipt(at: indexPath)
        : self.roomDataManager.getRoomReceipt(at: indexPath)
    }
    
    /// 해당 IndexPath가 마지막 셀인지 판단하는 메서드
    func isLastCell(indexPath: IndexPath) -> Bool? {
        if self._isSearchMode {
            if let numOfReceipts = self.roomDataManager.getNumOfUserReceipts(section: indexPath.section) {
                return indexPath.row == numOfReceipts - 1
            }
        } else {
            if let numOfReceipts = self.roomDataManager.getNumOfRoomReceipts(section: indexPath.section) {
                return indexPath.row == numOfReceipts - 1
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    /// IndexPath 배열에서 IndexSet 생성
    func createIndexSet(from indexPaths: [IndexPath]) -> IndexSet {
        let sections = Set(indexPaths.map { $0.section })
        return IndexSet(sections)
    }
    
    
    
    
    
    
    
//    /// IndexPath 배열에서 섹션 배열로 변환
//    func indexPathsToArraySet(_ indexPaths: [IndexPath]) -> Set<Int> {
//        return Set(indexPaths.map { $0.section })
//    }
//
    
    
    
    
    
    // 섹션 추가 / 삭제
    // 추가하려는 섹션의 index가 현재 데이터소스와 비교하여 맞는지 확인
    // 추가하려는 섹션의 index(5) <= 데이터 소스(7)
    // 현재 존재하는 행의 수 + 추가하려는 행의 수 == 데이터 소스의 행의 수
    // 행 추가
    // 현재 존재하는 행의 수 + 추가하려는 행의 수 == 데이터 소스의 행의 수
    // 현재 존재하는 행의 수 - 삭제하려는 행의 수 == 데이터 소스의 행의 수
    
    // 리로드
    // 해당 섹션이 존재하는지 확인
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 섹션 유효성 검사
    func isValidSectionChangeCount(
        receiptSections: [(key: String, indexPaths: [IndexPath])],
        currentSectionCount: Int // 현재 테이블뷰의 섹션 수
    ) -> Bool {
        // 섹션 추가와 삭제 데이터를 필터링
        let insertSectionData = receiptSections.filter { $0.key == DataChangeType.sectionInsert.notificationName }
        let removeSectionData = receiptSections.filter { $0.key == DataChangeType.sectionRemoved.notificationName }
        
        // 삽입할 섹션 데이터 유효성 검사
        let validInserts = self.areSectionsValid(from: insertSectionData)
        if !validInserts {
            return false
        }
        
        // 제거할 섹션 데이터 유효성 검사
        let validRemovals = self.areSectionsValid(from: removeSectionData)
        if !validRemovals {
            return false
        }
        
        // 섹션 수의 최종 유효성 검사
        let finalSectionCount = currentSectionCount + insertSectionData.count - removeSectionData.count
        
        return finalSectionCount == self.numOfSections
    }

    // 섹션 유효성 검사
    private func areSectionsValid(
        from receiptSections: [(key: String, indexPaths: [IndexPath])]
    ) -> Bool {
        // 가져온 데이터들의 섹션을 Int 배열로 만듦
        let sections = receiptSections.flatMap { $0.indexPaths.map { $0.section } }
        
        // Set을 활용하여 중복을 제거
        let uniqueSections = Array(Set(sections))
        
        // 배열의 Int 값이 현재 섹션 수와 맞는지 확인
        return !uniqueSections.contains { $0 < 0 || $0 >= self.numOfSections }
    }
}



















// MARK: - 리로드 유효성 검사
extension ReceiptTableViewVM {
    /// 주어진 영수증 섹션들에 대해 행을 재로드할 수 있는지 확인
    /// - Parameters:
    ///   - receiptSections: 섹션 키와 인덱스 경로를 담은 튜플의 배열
    ///   - numberOfRowsInSection: 섹션의 행 수를 반환하는 클로저입니다. 섹션이 없는 경우 nil을 반환
    /// - Returns: 모든 섹션의 행이 유효하면 true, 그렇지 않으면 false를 반환
    func canReloadRows(
        in receiptSections: [(key: String, indexPaths: [IndexPath])],
        numberOfRowsInSection: (Int) -> Int?
    ) -> Bool {
        // 업데이트하려는 데이터를 필터링
        let updatedData = receiptSections.filter { $0.key == DataChangeType.updated.notificationName }
        
        // 빈칸이라면 (업데이트하려는 데이터가 없다면)
        guard !updatedData.isEmpty else { return true }
        
        // 필터링한 데이터를 for_in을 통해 유효성 검사
        for (_, indexPaths) in updatedData {
            guard
                // 섹션을 가져오기
                let section = indexPaths.first?.section,
                // 클로저를 통해 뷰컨트롤러에 있는 테이블뷰에 접근하여, 해당 섹션의 행을 가져옴
                let currentRowCount = numberOfRowsInSection(section),
                // 모든 인덱스 경로의 행 번호가 유효한지 확인
                indexPaths.allSatisfy({ $0.row < currentRowCount }),
                // 리로드할 수 있는지 유효성 검사
                self.areAllIndexPathsValid(indexPaths)
            else {
                return false
            }
        }
        return true
    }
    
    /// 주어진 인덱스 경로 배열의 모든 인덱스 경로가 현재 데이터 컨텍스트에서 유효한지 확인
    /// - Parameter indexPaths: 유효성을 검사할 인덱스 경로 배열
    /// - Returns: 모든 인덱스 경로가 유효하면 true, 그렇지 않으면 false를 반환
    private func areAllIndexPathsValid(_ indexPaths: [IndexPath]) -> Bool {
        // 모든 인덱스 경로에 대해 다음을 확인
        return indexPaths.allSatisfy { [weak self] indexPath in
            
            guard
                // self 옵셔널 바인딩
                let self = self,
                // 섹션이 0이상이어야 함
                indexPath.section >= 0,
                // 인덱스 경로의 섹션이 유효한지
                indexPath.section < self.numOfSections,
                // 해당 섹션의 행 수가 유효한지 확인
                let numOfRowsInSection = self.numOfRows(in: indexPath.section)
            else {
                // 하나라도 유효하지 않으면 false를 반환
                return false
            }
            // 인덱스 경로의 행 번호가 유효한지 확인
            return indexPath.row >= 0 && indexPath.row < numOfRowsInSection
        }
    }
}



















// MARK: - 행 유효성 검사
extension ReceiptTableViewVM {
    func isValidRowsChanged(
        _ receiptSections: [(key: String, indexPaths: [IndexPath])],
        numberOfRowsInSection: (Int) -> Int?
    ) -> Bool {
        let insertRowsData = receiptSections.filter { $0.key == DataChangeType.added.notificationName }
        let removeRowsData = receiptSections.filter { $0.key == DataChangeType.removed.notificationName }
        
        if !insertRowsData.isEmpty {
            
            let insertSectionData = receiptSections
                .filter { $0.key == DataChangeType.sectionInsert.notificationName }
                .flatMap { $0.indexPaths.map { $0.section } }
            
            if !self.validateChanges(
                isInsert: true,
                receiptSections: insertRowsData,
                sectionChanges: insertSectionData,
                numberOfRowsInSection: numberOfRowsInSection)
            {
                return false
            }
        }
        if !removeRowsData.isEmpty {
            let sectionRemovedData = receiptSections
                .filter { $0.key == DataChangeType.sectionRemoved.notificationName }
                .flatMap { $0.indexPaths.map { $0.section } }
            
            if !self.validateChanges(
                isInsert: false,
                receiptSections: removeRowsData, 
                sectionChanges: sectionRemovedData,
                numberOfRowsInSection: numberOfRowsInSection)
            {
                return false
            }
        }
        
        return true
    }
    
    
    private func validateChanges(
        isInsert: Bool,
        receiptSections: [(key: String, indexPaths: [IndexPath])],
        sectionChanges: [Int],
        numberOfRowsInSection: (Int) -> Int?
    ) -> Bool {
        var validatedSections: Set<Int> = []
        
        for (_, indexPath) in receiptSections {
            guard let section = indexPath.first?.section else { return false }
            // 이미 유효성 검사를 완료한 섹션인지 확인
            guard !validatedSections.contains(section) else { continue }
            
            // 해당 데이터에서 section과 같은 섹션의 데이터의 개수를 가져옴
            let rowCountChange = self.filteredSections(
                isInsert: isInsert,
                section: section,
                receiptSections: receiptSections
            )
            
            
            // 섹션 변경 목록에 해당 섹션이 포함되어 있는지 확인
            
            
            
            var tableViewRows: Int?
            var dataSourceRows: Int?
            
            if isInsert {
                tableViewRows = sectionChanges.contains(section)
                ? 0
                : numberOfRowsInSection(section)
                
                dataSourceRows = self.numOfRows(in: section)
                
            } else {
                tableViewRows = numberOfRowsInSection(section)
                dataSourceRows = sectionChanges.contains(section)
                ? 0
                : self.numOfRows(in: section)
            }
            
            guard
                // 클로저를 통해 데이터 가져오기
                let tableViewRows = tableViewRows,
                // 데이터 소스에 있는 행의 개수를 가져옴
                let dataSourceRows = dataSourceRows,
                // 테이블뷰 행 + 추가하려는 행 == 데이터소스 행
                tableViewRows + rowCountChange == dataSourceRows
            else {
                print("\(#function) ----- -3")
                return false
            }
            print("\(#function) ----- 4")
            // 유효성 검사를 완료한 섹션을 추가
            validatedSections.insert(section)
        }
        
        return true
    }
    
    
    
    
    
    
    private func filteredSections(
        isInsert: Bool,
        section: Int,
        receiptSections: [(key: String, indexPaths: [IndexPath])]
    ) -> Int {
        // 해당 섹션을 포함하는 항목에서 indexPaths의 수를 세기
        return receiptSections
            .flatMap { $0.indexPaths } // 각 항목에서 indexPaths 추출
            .filter { $0.section == section } // 해당 섹션의 indexPaths 필터링
            .count // 결과의 개수 반환
        * (isInsert ? 1 : -1)
    }
}






extension Array {
    /// 배열의 요소를 안전하게 접근하기 위한 확장 메서드
    /// 이 메서드는 배열의 인덱스가 범위를 벗어날 경우 nil을 반환하여 안전하게 요소에 접근할 수 있도록 함
    subscript(safe index: Int) -> Element? {
        // 배열의 인덱스 범위에 해당 인덱스가 포함되어 있는지 확인
        // indices는 배열의 유효한 인덱스 범위를 나타내는 속성
        if indices.contains(index) {
            // 위 조건문에서, 인덱스가 유효하면 배열의 해당 인덱스 요소를 반환
            return self[index]
        } else {
            print("DEBUG: Index \(index) out of bounds for array of size \(self.count)")
            // 유효하지 않으면 nil을 반환하여 안전한 접근을 보장
            return nil
        }
        //        return indices.contains(index) ? self[index] : nil
    }
}
