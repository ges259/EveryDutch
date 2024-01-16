//
//  SettlementDetailsTableCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

struct UsersTableViewCellVM: UsersTableViewCellVMProtocol {
    var profileImageURL: String = ""
    var userName: String = ""
    
    
    var cumulativeAmount: Int
    var paybackPrice: Int
    
    var userID: String
    
    
    var customTableEnum: CustomTableEnum
    
    
    init(userID: String,
         moneyData : Int,
         paybackPrice: Int,
         roomUsers: RoomUsers,
         customTableEnum: CustomTableEnum) {
        self.userID = userID
        self.cumulativeAmount = moneyData
        
        self.paybackPrice = paybackPrice
        
        self.profileImageURL = roomUsers.roomUserImg
        self.userName = roomUsers.roomUserName
        
        self.customTableEnum = customTableEnum
    }
    
    
    
    
    
    
    // MARK: - 이미지 설정
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? UIImage.person_Fill_Img
        : UIImage.person_Img
        // MARK: - Fix
    }
    
    
    var rightBtnImg: UIImage? {
        switch self.customTableEnum {
        case .isSettleMoney:
            return UIImage.chevronRight
        case .isRoomSetting:
            return UIImage.gear_Fill_Img
        // 없음
        case .isSettle:
            return UIImage.Exit_Img
        }
    }
}
