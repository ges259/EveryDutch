//
//  ReceiptWirteVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

protocol ReceiptWirteVMProtocol {
    
    
    var numOfUsers: Int { get }
    var roomUsers: RoomUserDataDictionary { get }
    
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM
    
}
