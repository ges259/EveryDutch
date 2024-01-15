//
//  RoomSettingVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

protocol RoomSettingVMProtocol {
//    var makeCellClosure: (([RoomUsers]) -> Void)? { get set }
    
    func getUserData() -> RoomUserDataDictionary
    var getRoomMoneyData: [CumulativeAmount] { get }
}
