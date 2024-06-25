//
//  SettlementRoomProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol SettleMoneyRoomProtocol {
    
    
    
    
    
    var navTitle: String? { get }
    
    
    
    
    
    
    
    // MARK: - 탑뷰 크기 조절
    var initialHeight: CGFloat { get set }
    var currentTranslation: CGPoint { get set }
    var currentVelocity: CGPoint { get set }
    var getMaxAndMinHeight: CGFloat { get }
    
    var topViewHeightPlag: Bool { get set }
    
    
    
    
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
    var isTopViewOpen: Bool { get set }
    
    
    // MARK: - API
    func loadMoreReceiptData()
    
    
    // User data handling
    func userDataChanged(_ userInfo: [String: [IndexPath]])
    func getPendingUserDataIndexPaths() -> [String: [IndexPath]]
    func resetPendingUserDataIndexPaths()
    
    // Receipt data handling
    func receiptDataChanged(_ userInfo: [String: [IndexPath]])
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]]
    func getPendingReceiptSections() -> [String: [Int]]
    func resetPendingReceiptIndexPaths()
    
    
    //    var numberOfReceipt: Int { get }
        var numOfSection: Int { get }
        func numberOfReceipt(section: Int) -> Int
    //    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol
    //    func getReceipt(at index: Int) -> Receipt
        
        func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol
        
        func getReceipt(at indexPath: IndexPath) -> Receipt
    func getReceiptSectionDate(section: Int) -> String 
}

protocol ReceiptTableViewProtocol {

    var numberOfReceipt: Int { get }
    
    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol
    func getReceipt(at index: Int) -> Receipt
    
    
//    var numOfSection: Int { get }
//    func numberOfReceipt(section: Int) -> Int
//    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol
//    
//    func getReceipt(at indexPath: IndexPath) -> Receipt
}
