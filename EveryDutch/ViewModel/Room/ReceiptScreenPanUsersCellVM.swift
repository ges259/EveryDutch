//
//  ReceiptScreenPanCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

struct ReceiptScreenPanUsersCellVM: ReceiptScreenPanUsersCellVMProtocol, UserPriceDataProtocol {
    var user: User?
    var paymentDetail: PaymentDetail
    
    
    var getUserName: String {
        return self.user?.userName ?? "???"
    }
    var getPay: Int {
        return self.paymentDetail.pay
    }
    var getUserID: String {
        return self.paymentDetail.userID
    }
    
    mutating func changeDoneValue(_ bool: Bool) {
        self.paymentDetail.done = bool
    }
    
    
    
    var doneStatusChanged: ((UIImage?) -> Void)?
    
    
    
    
    init(roomUser: User?,
         paymentDetail: PaymentDetail) {
        self.user = roomUser
        self.paymentDetail = paymentDetail
        // MARK: - Fix
        // 클로저가 굳이 필요할까?
        self.doneStatusChanged?(self.doneImg)
    }

    
    
    

    
    var doneImg: UIImage? {
        return self.paymentDetail.done
        ? .check_Square_Img
        : .empty_Square_Img
    }
    var profileImg: UIImage? {
        return self.user?.userProfile == ""
        ? .person_Fill_Img
        : .x_Mark_Img
    }
}
