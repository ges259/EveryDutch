//
//  SettlementDetailsTableCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

struct UsersTableViewCellVM: UsersTableViewCellVMProtocol {
    var profileImageURL: String
    var userName: String
    var price: String
    var customTableEnum: CustomTableEnum

    init(roomUsers: RoomUsers,
         customTableEnum: CustomTableEnum) {
        self.profileImageURL = roomUsers.roomImg
        self.userName = roomUsers.roomName
        self.price = roomUsers.userID
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
