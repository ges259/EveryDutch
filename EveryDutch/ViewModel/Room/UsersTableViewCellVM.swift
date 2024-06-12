//
//  SettlementDetailsTableCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

struct UsersTableViewCellVM: UsersTableViewCellVMProtocol {
    
    var userID: String
    private var roomUser: User
    var customTableEnum: UsersTableEnum
    
    
    var cumulativeAmount: Int = 0
    var paybackPrice: Int = 0
    
    
    
    
    
    // MARK: - 라이프사이클
    init(userID: String,
         roomUsers: User,
         customTableEnum: UsersTableEnum)
    {
        self.userID = userID
        self.roomUser = roomUsers
        self.customTableEnum = customTableEnum
    }
    
    
    
    var getRoomUserDataDict: RoomUserDataDict {
        return [self.userID: self.roomUser]
    }
    
    var getUser: User {
        return self.roomUser
    }
    var getUserName: String {
        return self.roomUser.userName
    }
}
    
    
    
    
    
    
    



// MARK: - 이미지
extension UsersTableViewCellVM {
    /// 프로필 이미지 설정
    var profileImg: UIImage? {
        return self.roomUser.userProfile == ""
        ? UIImage.person_Fill_Img
        : UIImage.person_Img
        // MARK: - Fix
    }
    /// 오른쪽 이미지
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
    /// 이미지 사용 여부
    var isButtonExist: Bool {
        switch self.customTableEnum {
        case .isSettleMoney, .isRoomSetting:
            return true
        case .isSettle:
            return false
        }
    }
    /// 이미지 왼쪽 Anchor
    var imgLeftAnchor: CGFloat {
        switch self.customTableEnum {
        case .isSettleMoney, .isRoomSetting:
            return -20
        case .isSettle:
            return -10
        }
    }
}

// MARK: - 데이터 수정
extension UsersTableViewCellVM {
    mutating func updateUserData(_ user: [String: Any]) {
        guard !user.isEmpty,
              let key = user.keys.first,
              let value = user.values.first as? String
        else { return }
        
        switch key {
        case DatabaseConstants.user_name:
            self.roomUser.userName = value
            break
        case DatabaseConstants.personal_ID:
            self.roomUser.personalID = value
            break
        case DatabaseConstants.user_image:
            self.roomUser.userProfile = value
            break
        default: break
        }
    }
    
    mutating func setCumulativeAmount(_ amount: Int) {
        self.cumulativeAmount = amount
    }
    mutating func setPayback(_ amount: Int) {
        self.paybackPrice = amount
    }
}
