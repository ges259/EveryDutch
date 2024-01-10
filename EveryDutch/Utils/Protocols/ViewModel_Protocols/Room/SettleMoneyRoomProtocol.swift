//
//  SettlementRoomProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol SettleMoneyRoomProtocol {
    func cellViewModel(at index: Int) -> SettlementTableViewCellVM
    var numberOfReceipt: Int { get }
    var roomData: Rooms { get }
    var receipts: [Receipt] { get }
}
