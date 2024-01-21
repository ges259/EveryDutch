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
    
    
    
    var debouncingClosure: (() -> Void)? { get set }
    var keyboardHeight: CGFloat { get set }
    
    
    func setDebouncing(stop: Bool)
//    func setVariableTrue()
    var isTableViewEditing: Bool { get }

    
    // 클로저
    var calculatePriceClosure: ((String?) -> Void)? { get set }
    
    // 최대 글자 수
    var TF_MAX_COUNT: Int { get }
    
    // 기타
    var tableIsHidden: Bool { get }
    var numOfUsers: Int { get }
    
    //
    var priceInfoTFText: String? { get }
    var moneyCountLblText: String? { get }
    
    // 가격 텍스트필드
    func calculatePrice(userID: String, price: Int?)
    func formatPriceForEditing(_ newText: String?) -> String?
    func savePriceText(text: String?)
    func removeWonFormat(priceText: String?) -> String?
    func updateMemoCount(count: Int) -> String
    
    
    
    
    
    
    
    // 타임 피커
    func timePickerString(hour: Int, minute: Int) -> String
    func timePickerFormat(_ row: Int) -> String
    
    // 단일 선택
    func isPayerSelected(user: RoomUserDataDictionary) -> String?
    
    // 다중 선택
    func makeCellVM(selectedUsers: RoomUserDataDictionary)
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM
    func deleteCellVM(userID: String?)
}
