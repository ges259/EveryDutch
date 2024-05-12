//
//  SettlementRoomProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol SettleMoneyRoomProtocol {
    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol
    var numberOfReceipt: Int { get }
    
    var bottomBtnTitle: String { get }
    var navTitle: String? { get }
    var isSearchMode: Bool { get set }
    var isTopViewBtnIsHidden: Bool { get }
    
    
    
    
    
    
    // MARK: - 탑뷰 크기 조절
    var initialHeight: CGFloat { get set }
    var currentTranslation: CGPoint { get set }
    var currentVelocity: CGPoint { get set }
    var getMaxAndMinHeight: CGFloat { get }
    
    
    
//    var fetchUserClosure: ((RoomUserDataDictionary) -> Void)? { get set }
    
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
    var isTopViewOpen: Bool { get set }
    
    
    
    
    
    
    
    func userDataChanged(_ userInfo: [String: [IndexPath]])
    
//    // 모든 대기 중인 변경 사항 초기화
//    func resetPendingUserIndexPaths()
//    // 뷰모델에 저장된 변경 사항 반환
//    func getPendingUserIndexPaths() -> [String: [IndexPath]]
    
    // User data handling

    func getPendingUserDataIndexPaths() -> [String: [IndexPath]]

    func resetPendingUserDataIndexPaths()
    // Receipt data handling
    func receiptDataChanged(_ userInfo: [String: [IndexPath]])

    func getPendingReceiptIndexPaths() -> [String: [IndexPath]]

    func resetPendingReceiptIndexPaths()
}
