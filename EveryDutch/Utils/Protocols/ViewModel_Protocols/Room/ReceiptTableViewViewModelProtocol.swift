//
//  ReceiptTableViewViewModelProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 6/28/24.
//

import UIKit

protocol ReceiptTableViewViewModelProtocol: NotificationUpdateProtocol {
    
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
}




protocol NotificationUpdateProtocol {
    // 노티피케이션
    var isNotificationError: ErrorEnum? { get }
    func receiptDataChanged(_ userInfo: [String: Any])
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]]
    func getPendingReceiptSections() -> [String: [Int]]
    func resetPendingReceiptIndexPaths()
}
