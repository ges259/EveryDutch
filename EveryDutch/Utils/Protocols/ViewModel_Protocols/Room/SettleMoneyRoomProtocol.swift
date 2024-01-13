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
    var roomData: Rooms { get }
    var receipts: [Receipt] { get }
    var receiptChangedClosure: (() -> Void)? { get }
    var userChangedClosure: (([RoomUsers]) -> Void)? { get }
    var fetchUserClosure: (([RoomUsers]) -> Void)? { get }
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
    var topViewIsOpen: Bool { get }
}
