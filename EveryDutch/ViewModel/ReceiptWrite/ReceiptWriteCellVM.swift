//
//  ReceiptWriteCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

struct ReceiptWriteCellVM: ReceiptWriteCellVMProtocol {
    var userID: String
    var profileImageURL: String
    var userName: String
    
    var roomUserDataDictionary: RoomUserDataDictionary = [:]

    
    
    
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? UIImage.person_Fill_Img
        : UIImage.x_Mark_Img
    }
    
    
    // MARK: - 라이프사이클
    init(userID: String,
         roomUsers: RoomUsers) {
        self.userID = userID
        self.profileImageURL = roomUsers.roomUserImg
        self.userName = roomUsers.roomUserName
        
        self.roomUserDataDictionary = [userID: roomUsers]
    }
    
    /// 가격 텍스트필드의 alpha값을 설정
    func priceTFAlpha(isSelected: Bool) -> CGFloat {
        return isSelected
        ? 1
        : 0
    }
    
    
    
    
    // MARK: - 가격 레이블 형식 설정
    func configureLblFormat(price: String) -> String? {
        guard let price = Int(price) else { return "0원" }
        
        return price == 0
        ? "0원"
        // formatNumberString() -> 10,000처럼 바꾸기
        : NumberFormatter.formatString(price: price)
    }
    
    // MARK: - 가격 텍스트필드 형식 설정
    func configureTfFormat(text: String?) -> String? {
        return NumberFormatter.formatStringChange(
            price: text)
    }
    
    // MARK: - 형식 제거
    func removeFormat(text: String?) -> String {
        let textString = NumberFormatter.removeFormat(price: text) ?? "0"
        return textString
    }
    
    // MARK: - 0원인지 확인하는 메서드
    func textIsZero(text: String?) -> String? {
        return text == "0"
        ? ""
        : text
    }
    
    
    
    
}
