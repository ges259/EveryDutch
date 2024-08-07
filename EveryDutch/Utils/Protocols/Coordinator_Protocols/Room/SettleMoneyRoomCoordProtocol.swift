//
//  SettlementRoomCoordinating.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol SettleMoneyRoomCoordProtocol: Coordinator {
    func RoomSettingScreen()
    func receiptWriteScreen()
    func ReceiptScreen(receipt: Receipt)
    
    
    func userProfileScreen()
}
