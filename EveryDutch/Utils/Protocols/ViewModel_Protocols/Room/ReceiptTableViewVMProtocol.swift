//
//  ReceiptTableViewViewModelProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 6/28/24.
//

import UIKit

protocol ReceiptTableViewVMProtocol: NotificationUpdateProtocol {
    
    var isSearchMode: Bool { get }
    func hasNoMoreDataSetTrue()
    var hasNoMoreData: Bool { get }
    
    var haederSectionBackgroundColor: UIColor { get }
    
    // 영수증 테이블뷰 (delgate / dataSource)
    var numOfSections: Int { get }
    func numOfRows(in section: Int) -> Int?
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol?
    func getReceipt(at indexPath: IndexPath) -> Receipt?
    func getReceiptSectionDate(section: Int) -> String?
    
    func isLastCell(indexPath: IndexPath) -> Bool?
    
    
    
    
    
    func createIndexSet(from indexPaths: [IndexPath]) -> IndexSet
    
    
    
    
//    
//    
//    
//    func filteredSections(
//        isInsert: Bool,
//        section: Int,
//        receiptSections: [(key: String, indexPaths: [IndexPath])]
//    ) -> Int 
    
    
    
    /// IndexPath 배열에서 섹션 배열로 변환
//    func indexPathsToArraySet(_ indexPaths: [IndexPath]) -> Set<Int> 
    
    // 리로드 유효성 검사
//    func canReloadRows(_ indexPaths: [IndexPath]) -> Bool
    
    
    func isValidSectionChangeCount(
        receiptSections: [(key: String, indexPaths: [IndexPath])],
        currentSectionCount: Int // 현재 테이블뷰의 개수
    ) -> Bool
//    
//    func isValidRowInsertCount(currentSection: Int,
//                               rowInsertCount: Int,
//                               currentRowCount: Int
//    ) -> Bool 
//    
    
    func isValidRowsChanged(
        _ receiptSections: [(key: String, indexPaths: [IndexPath])],
        numberOfRowsInSection: (Int) -> Int?
    ) -> Bool 
    func canReloadRows(
        in receiptSections: [(key: String, indexPaths: [IndexPath])],
        numberOfRowsInSection: (Int) -> Int?
    ) -> Bool
    
    
}




protocol NotificationUpdateProtocol {
    // 노티피케이션
    var isNotificationError: ErrorEnum? { get }
    func receiptDataChanged(_ userInfo: [String: Any])
    func searchDataChanged(_ userInfo: [String: Any]) 
    func getPendingReceiptIndexPaths() -> [(key: String, indexPaths: [IndexPath])]
    func resetPendingReceiptIndexPaths()
}
