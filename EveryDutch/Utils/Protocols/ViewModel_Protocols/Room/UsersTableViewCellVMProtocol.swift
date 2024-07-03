//
//  UsersTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

// ReceiptWriteDataCell과 ReceiptWriteUserCell셀 공통의 프로토롤을 가지는데,
// ReceiptWriteUserCell과 UsersTableViewCell과의 차이는 없기 때문에 UsersTableViewCellVMProtocol에도 ReceiptWriteCellVMProtocol를 상속 받음.
protocol ReceiptWriteCellVMProtocol {}



protocol UsersTableViewCellVMProtocol: ReceiptWriteCellVMProtocol, UserPriceDataProtocol {
    
    var cumulativeAmount: Int { get }
    var customTableEnum: UsersTableEnum { get }
    
    

    
    var rightBtnImg: UIImage? { get }
    var paybackPrice: Int { get }
    
    
    
    var isButtonExist: Bool { get }
    var imgLeftAnchor: CGFloat { get }
    
    
    var getUserName: String { get }
    
    var userID: String { get }
    
    
    
    
    var imageUrl: String? { get }
    
     
    
    mutating func updateUserData(_ user: [String: Any])
    
    mutating func setCumulativeAmount(_ amount: Int)
    mutating func setPayback(_ amount: Int)
    
    
    
    
    
    var getRoomUserDataDict: RoomUserDataDict { get }
    var getUser: User { get }
}


//protocol UsersImageProtocol {
//
//}
//
//extension UsersImageProtocol {
//    var baseImage: UIImage? {
//        return UIImage.person_Fill_Img
//    }
//}
//


protocol UserPriceDataProtocol {
    
}
extension UserPriceDataProtocol {
    /// 가격 레이블 형식 설정
    /// '10000' -> '10,000원' 으로 바꾸기
    func configureLblFormat(price: String) -> String? {
        guard let price = Int(price) else { return "0원" }
        
        return price == 0
        ? "0원"
        : NumberFormatter.formatString(price: price)
    }
    
    /// 가격이 변하면, 텍스트필드 형식을 유지하며 변환
    /// '10,000원' -> '15,000원' 으로 바꾸기
    func configureTfFormat(text: String?) -> String? {
        return NumberFormatter.formatStringChange(price: text)
    }
    
    /// 가격 텍스트필드 형식 제거
    /// '10,000원' -> '10000' 으로 바꾸기
    func removeFormat(text: String?) -> String {
        let textString = NumberFormatter.removeFormat(price: text) ?? "0"
        return textString
    }
    
    
    
    /// 0원인지 확인하는 메서드
    func textIsZero(text: String?) -> String? {
        return text == "0"
        ? ""
        : text
    }
    
    /// 가격 텍스트필드의 alpha값을 설정
    func priceTFAlpha(isSelected: Bool) -> CGFloat {
        return isSelected
        ? 1
        : 0
    }
}
