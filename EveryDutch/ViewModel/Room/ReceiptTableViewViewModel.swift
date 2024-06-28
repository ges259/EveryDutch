//
//  ReceiptTableViewViewModel.swift
//  EveryDutch
//
//  Created by 계은성 on 6/28/24.
//

import UIKit

final class ReceiptTableViewViewModel: ReceiptTableViewViewModelProtocol {
    
    // MARK: - 모델
    private var _receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    private var _receiptSearchModeDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    private let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 플래그
    private let _isSearchMode: Bool
    private var _hasNoMoreData: Bool = false
    
    
    
    // MARK: - 라이프사이클
    init (roomDataManager: RoomDataManagerProtocol,
          isSearchMode: Bool) {
        self.roomDataManager = roomDataManager
        self._isSearchMode = isSearchMode
    }
}





extension ReceiptTableViewViewModel {
    // MARK: - 플래그 변경
    func hasNoMoreDataSetTrue() {
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





// MARK: - 테이블뷰
extension ReceiptTableViewViewModel {
    /// 섹션의 타이틀(날짜)를 반환
    func getReceiptSectionDate(section: Int) -> String {
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
    func numOfReceipts(section: Int) -> Int {
        return self._isSearchMode
        ? self.roomDataManager.getNumOfUserReceipts(section: section)
        : self.roomDataManager.getNumOfRoomReceipts(section: section)
    }
    /// 영수증 셀의 뷰모델 반환
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceiptViewModel(indexPath: indexPath)
        : self.roomDataManager.getRoomReceiptViewModel(indexPath: indexPath)
    }
    /// 셀 선택 시, 해당 셀의 영수증 반환
    func getReceipt(at indexPath: IndexPath) -> Receipt {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceipt(at: indexPath)
        : self.roomDataManager.getRoomReceipt(at: indexPath)
    }
    func isLastCell(indexPath: IndexPath) -> Bool {
        return self._isSearchMode
        ? indexPath.row == self.roomDataManager.getNumOfUserReceipts(section: indexPath.section) - 1
        : indexPath.row == self.roomDataManager.getNumOfRoomReceipts(section: indexPath.section) - 1
    }
}





// MARK: - 인덱스패스
extension ReceiptTableViewViewModel {
    var isNotificationError: ErrorEnum? {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.error
        : self._receiptDataManager.error
    }
    
    // 영수증 데이터 인덱스패스
    func receiptDataChanged(_ userInfo: [String: Any]) {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.dataChanged(userInfo)
        : self._receiptDataManager.dataChanged(userInfo)
    }
    
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]] {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.getPendingIndexPaths()
        : self._receiptDataManager.getPendingIndexPaths()
    }
    func getPendingReceiptSections() -> [String: [Int]] {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.getPendingSections()
        : self._receiptDataManager.getPendingSections()
    }

    func resetPendingReceiptIndexPaths() {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.resetIndexPaths()
        : self._receiptDataManager.resetIndexPaths()
    }
}

