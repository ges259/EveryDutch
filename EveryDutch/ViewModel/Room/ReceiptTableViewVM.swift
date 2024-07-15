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
        print("\(#function) ----- \(self._isSearchMode) ----- \(self._receiptSearchModeDataManager.error)")
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.error
        : self._receiptDataManager.error
    }
    
    // 영수증 데이터 인덱스패스
    func receiptDataChanged(_ userInfo: [String: Any]) {
        print("___________________________")
        print(#function)
        print("isSeachMode: \(self._isSearchMode)")
        dump(userInfo)
        print("___________________________")
        self._receiptDataManager.dataChanged(userInfo)
    }
    func searchDataChanged(_ userInfo: [String: Any]) {
        print("___________________________")
        print(#function)
        print("isSeachMode: \(self._isSearchMode)")
        dump(userInfo)
        print("___________________________")
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











extension Array {
    // 배열의 요소를 안전하게 접근하기 위한 확장 메서드
    // 이 메서드는 배열의 인덱스가 범위를 벗어날 경우 nil을 반환하여 안전하게 요소에 접근할 수 있도록 함
    subscript(safe index: Int) -> Element? {
        // 배열의 인덱스 범위에 해당 인덱스가 포함되어 있는지 확인
        // indices는 배열의 유효한 인덱스 범위를 나타내는 속성
        return indices.contains(index) ? self[index] : nil
        // 위 조건문에서, 인덱스가 유효하면 배열의 해당 인덱스 요소를 반환
        // 유효하지 않으면 nil을 반환하여 안전한 접근을 보장
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
    func numOfReceipts(section: Int) -> Int? {
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
    
    
    
    
    
    
    
    
    
    

    /// 테이블뷰의 섹션을 insert/delete 할 때, [현재 섹션]의 개수와 [기존 섹션 + 추가하려는 섹션]의 개수를 비교
    func validateSectionCountChange(
        currentSectionCount: Int,
        changedSectionsCount: Int
    ) -> Bool {
        return currentSectionCount + changedSectionsCount == self.numOfSections
    }

    /// 테이블뷰의 셀을 insert/delete 할 때, [현재 셀]의 개수와 [기존 셀 + 추가하려는 셀]의 개수를 비교
    func validateRowCountChange(
        sectionTuple: [(sectionIndex: Int,
                        currentRowCount: Int,
                        changedUsersCount: Int)]
    ) -> Bool {
        for tuple in sectionTuple {
            let expectedRowCount = tuple.currentRowCount + tuple.changedUsersCount
            
            if let actualRowCount = self.numOfReceipts(section: tuple.sectionIndex),
                expectedRowCount != actualRowCount
            {
                return false
            }
        }
        return true
    }

    /// 테이블뷰의 셀을 reload할 때, 해당 셀의 index가 옳은지 확인
    func validateRowExistenceForUpdate(indexPaths: [IndexPath]) -> Bool {
        for indexPath in indexPaths {
            let section = indexPath.section
            let row = indexPath.row
            if let sectionRowCount = self.numOfReceipts(section: section), row >= sectionRowCount {
                return false
            }
        }
        return true
    }

    /// 테이블뷰의 섹션을 reload할 때, 해당 섹션이 유효한지 확인
    func validateSectionsExistenceForUpdate(indexPaths: [IndexPath]) -> Bool {
        let sections: [Int] = self.indexPathsToArraySet(indexPaths)
        return !sections.contains { $0 >= self.numOfSections }
    }

    /// IndexPath 배열에서 섹션 배열로 변환
    func indexPathsToArraySet(_ indexPaths: [IndexPath]) -> [Int] {
        return Array(Set(indexPaths.map { $0.section }))
    }

    /// IndexPath 배열에서 IndexSet 생성
    func createIndexSet(from indexPaths: [IndexPath]) -> IndexSet {
        let sections = Set(indexPaths.map { $0.section })
        return IndexSet(sections)
    }
}

