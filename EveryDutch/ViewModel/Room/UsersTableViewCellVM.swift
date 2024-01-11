//
//  SettlementDetailsTableCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

struct UsersTableViewCellVM {
    var profileImageURL: String
    var userName: String
    var price: String
    var customTableEnum: CustomTableEnum

    init(roomUsers: RoomUsers,
         customTableEnum: CustomTableEnum) {
        self.profileImageURL = roomUsers.roomImg
        self.userName = roomUsers.roomName
        self.price = roomUsers.personalID
        self.customTableEnum = customTableEnum
    }
    
    
    var btnIsSelected: Bool = false {
        didSet {
            self.onButtonSelectionChanged?(self.receiptScreenImg)
        }
    }
    var onButtonSelectionChanged: ((UIImage?) -> Void)?
    
    
    
    
    
    
    
    
    var addSubViewOnContentView: Bool {
        switch self.customTableEnum {
        case .isReceiptWrite, .isRoomSetting, .isReceiptScreen:
            return true
        case .isPeopleSelection, .isSearch, .isSettle, .isSettleMoney:
            return false
        }
    }
    
    
    var rightBtnIsHidden: Bool {
        return self.customTableEnum == .isSettle
        ? true
        : false
    }
    var textFieldIsHidden: Bool {
        return self.customTableEnum == .isReceiptWrite
        ? false
        : true
    }
    
    var rightBtnClosure: Bool {
        return false
    }
    
    
    
//    var
    
    
    
    
    // MARK: - 이미지 설정
    var profileImg: UIImage? {
        return self.profileImageURL == ""
        ? UIImage.person_Fill_Img
        : UIImage.person_Img
    }
    var receiptScreenImg: UIImage? {
        return self.btnIsSelected
        ? .check_Square_Img
        : .empty_Square_Img
    }
    
    var rightBtnImg: UIImage? {
        switch self.customTableEnum {
        case .isSettleMoney:
            return UIImage.chevronRight
        case .isReceiptWrite:
            return UIImage.x_Mark_Img
        case .isRoomSetting:
            return UIImage.gear_Fill_Img
        case .isReceiptScreen:
            return UIImage.empty_Square_Img
        // 속이 찬 원
        case .isPeopleSelection, .isSearch:
            return UIImage.circle_Fill_Img
        // 없음
        case .isSettle:
            return UIImage.Exit_Img
        }
    }
    
    var rightBtnTintColor: UIColor {
        return self.customTableEnum == .isPeopleSelection
        ? UIColor.deep_Blue
        : UIColor.black
    }
    

    mutating func rightBtnTapped() {
        self.btnIsSelected.toggle()
    }
}
