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
    var TF_MAX_COUNT: Int { get }
    
    func calculatePrice(userID: String?, price: Int?) -> String?
    
    var priceInfoTFText: String? { get }
    var moneyCountLblText: String? { get }
    
    var tableIsHidden: Bool { get }
    
    
    func removeFormat(price: String?) -> String?
    
    func timePickerString(hour: Int, minute: Int) -> String
    
    func timePickerFormat(_ row: Int) -> String
    
    
    func isPayerSelected(user: RoomUserDataDictionary) -> String?
    
    func makeCellVM(selectedUsers: RoomUserDataDictionary)
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM
    func deleteCellVM(userID: String?)
}
