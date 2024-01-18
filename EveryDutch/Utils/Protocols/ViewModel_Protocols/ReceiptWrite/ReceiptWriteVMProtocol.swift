//
//  ReceiptWirteVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

protocol ReceiptWriteVMProtocol {
    
    var time: String? { get set }
    var memo: String? { get set }
    var price: Int? { get set }
    var payer: RoomUserDataDictionary? { get }
    var selectedUsers: RoomUserDataDictionary { get set }
    
    var numOfUsers: Int { get }
    
    
    var getPriceString: String { get }
    
    
    
    
    func isPayerSelected(user: RoomUserDataDictionary) -> String?
    
    func makeCellVM(selectedUsers: RoomUserDataDictionary)
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM
    func deleteCellVM(userID: String?)
}
