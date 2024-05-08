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
    
    
    var cumulativeAmount: Int = 0
    var paybackPrice: Int = 0
    
    var userID: String
    
    
    var customTableEnum: UsersTableEnum
    
    private var roomUser: User
    
    init(userID: String,
         roomUsers: User,
         customTableEnum: UsersTableEnum) 
    {
        self.userID = userID
        self.profileImageURL = roomUsers.userProfile
        self.userName = roomUsers.userName
        self.roomUser = roomUsers
        self.customTableEnum = customTableEnum
    }
    
    
    
    
    
    // MARK: - 이미지 설정
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? UIImage.person_Fill_Img
        : UIImage.person_Img
        // MARK: - Fix
    }
    
    
    
// MARK: - [오른쪽 이미지]
    
    
    
    // MARK: - 이미지
    var rightBtnImg: UIImage? {
        switch self.customTableEnum {
        case .isSettleMoney:
            return UIImage.chevronRight
        case .isRoomSetting:
            return UIImage.gear_Fill_Img
        case .isSettle:
            return nil
        }
    }
    
    // MARK: - 이미지 사용 여부
    var isButtonExist: Bool {
        switch self.customTableEnum {
        case .isSettleMoney, .isRoomSetting:
            return true
        case .isSettle:
            return false
        }
    }
    
    // MARK: - 이미지 왼쪽 Anchor
    var imgLeftAnchor: CGFloat {
        switch self.customTableEnum {
        case .isSettleMoney, .isRoomSetting:
            return -20
        case .isSettle:
            return -10
        }
    }
    
    
    
    
    
    
    
    mutating func setCumulativeAmount(_ amount: Int) {
        self.cumulativeAmount = amount
    }
    mutating func setpayback(_ amount: Int) {
        self.paybackPrice = amount
    }
}
