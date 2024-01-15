//
//  SettlementRoomProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol SettleMoneyRoomProtocol {
    func cellViewModel(at index: Int) -> SettleMoneyTableViewCellVM
    var numberOfReceipt: Int { get }
    var receipts: [Receipt] { get }
    
    var receiptChangedClosure: (() -> Void)? { get set }
    var userChangedClosure: ((RoomUserDataDictionary) -> Void)? { get set }
    
    
//    var fetchUserClosure: ((RoomUserDataDictionary) -> Void)? { get set }
    var fetchMoneyDataClosure: (() -> Void)? { get set }
    
    
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
    var topViewIsOpen: Bool { get set }
}
