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
    
    
    
    
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? .person_Fill_Img
        : .x_Mark_Img
    }
    
    
    init(userID: String,
         roomUsers: RoomUsers) {
        self.userID = userID
        self.profileImageURL = roomUsers.roomUserImg
        self.userName = roomUsers.roomUserName
    }
    
    // MARK: - 가격 레이블 텍스트 설정
    func configureFormat(price: String?) -> String? {
        guard let price = Int(price ?? "0" ) else { return "0원" }
        
        return price == 0
        ? "0원"
        // formatNumberString() -> 10,000처럼 바꾸기
        : NumberFormatter.formatString(price: price)
    }
}
