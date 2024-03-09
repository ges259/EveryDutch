//
//  ReceiptScreenPanCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

struct ReceiptScreenPanUsersCellVM: ReceiptScreenPanUsersCellVMProtocol {
    
    var pay: Int
    var userID: String
    var done: Bool
    
    var userName: String
    var image: String
    
    
    init(roomUser: User,
         paymentDetail: PaymentDetail) {
        self.done = paymentDetail.done
        self.pay = paymentDetail.pay
        self.userID = paymentDetail.userID
        
        
        self.userName = roomUser.userName
        self.image = roomUser.userProfile
        
        
        // MARK: - Fix
        // 클로저가 굳이 필요할까?
        self.doneStatusChanged?(self.doneImg)
    }
    
    
    

    
    var doneImg: UIImage? {
        return self.done
        ? .check_Square_Img
        : .empty_Square_Img
    }
    var profileImg: UIImage? {
        return self.image == ""
        ? .person_Fill_Img
        : .x_Mark_Img
    }
    
    
    var doneStatusChanged: ((UIImage?) -> Void)?
    
    
    
    
    
    

    
    
    
    
}
