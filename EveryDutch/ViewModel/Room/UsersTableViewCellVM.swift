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
    
    



// MARK: - 가격 텍스트
extension UsersTableViewCellVM {
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
    
    
    
    
    
    
    

// MARK: - 데이터 수정
extension UsersTableViewCellVM {
    mutating func updateUserData(_ user: [String: Any]) -> User? {
        guard !user.isEmpty,
              let key = user.keys.first,
              let value = user.values.first as? String
        else { return nil }
        
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
        return self.roomUser
    }
    
    mutating func setCumulativeAmount(_ amount: Int) {
        self.cumulativeAmount = amount
    }
    mutating func setPayback(_ amount: Int) {
        self.paybackPrice = amount
    }
}
