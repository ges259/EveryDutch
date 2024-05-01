//
//  ReceiptWriteCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol ReceiptWriteCellVMProtocol {
    func getType() -> String

}


protocol ReceiptWriteUsersCellVMProtocol: ReceiptWriteCellVMProtocol {
    var userID: String { get }
    var profileImageURL: String { get }
    var userName: String { get }
    var profileImg: UIImage? { get }
    var roomUserDataDictionary: RoomUserDataDict { get }
    
    
    
    func priceTFAlpha(isSelected: Bool) -> CGFloat
    
    
    
    
    
    
    
    func configureLblFormat(price: String) -> String?
    
    
    func removeFormat(text: String?) -> String
    func textIsZero(text: String?) -> String?
    func configureTfFormat(text: String?) -> String?
}
extension ReceiptWriteUsersCellVMProtocol {
    func getType() -> String {
        return ""
    }

}
