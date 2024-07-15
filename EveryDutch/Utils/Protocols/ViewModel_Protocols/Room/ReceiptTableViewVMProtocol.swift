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
    func numOfReceipts(section: Int) -> Int?
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol?
    func getReceipt(at indexPath: IndexPath) -> Receipt?
    func getReceiptSectionDate(section: Int) -> String?
    
    func isLastCell(indexPath: IndexPath) -> Bool?
    
    
    /// 테이블뷰의 섹션을 insert/delete 할 때, [현재 섹션]의 개수와 [기존 섹션 + 추가하려는 섹션]의 개수를 비교
    func validateSectionCountChange(
        currentSectionCount: Int,
        changedSectionsCount: Int
    ) -> Bool
    
    /// 테이블뷰의 셀을 insert/delete 할 때, [현재 셀]의 개수와 [기존 셀 + 추가하려는 셀]의 개수를 비교
    func validateRowCountChange(
        sectionTuple: [(sectionIndex: Int,
                        currentRowCount: Int,
                        changedUsersCount: Int)]
    ) -> Bool     /// 테이블뷰의 셀을 reload할 때, 해당 셀의 index가 옳은지 확인
    func validateRowExistenceForUpdate(
        indexPaths: [IndexPath]
    ) -> Bool
    
    func validateSectionsExistenceForUpdate(
        indexPaths: [IndexPath]
    ) -> Bool
    
    func indexPathsToArraySet(_ indexPaths: [IndexPath]) -> [Int]
    func createIndexSet(from indexPaths: [IndexPath]) -> IndexSet
}




protocol NotificationUpdateProtocol {
    // 노티피케이션
    var isNotificationError: ErrorEnum? { get }
    func receiptDataChanged(_ userInfo: [String: Any])
    func searchDataChanged(_ userInfo: [String: Any]) 
    func getPendingReceiptIndexPaths() -> [(key: String, indexPaths: [IndexPath])]
    func resetPendingReceiptIndexPaths()
}
