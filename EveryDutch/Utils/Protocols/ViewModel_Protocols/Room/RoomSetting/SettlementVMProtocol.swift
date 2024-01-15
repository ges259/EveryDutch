//
//  SettlementVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation

protocol SettlementVMProtocol {
    func getUserData() -> RoomUserDataDictionary
    var getRoomMoneyData: [CumulativeAmount] { get }
}
