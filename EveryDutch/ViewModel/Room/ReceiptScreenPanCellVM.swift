//
//  ReceiptScreenPanCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

struct ReceiptScreenPanCellVM {
    
    var pay: Int
    var userID: String
    var image: String
    var userName: String
    var done: Bool {
        didSet {
            self.doneStatusChange_API()
            self.doneStatusChanged?(self.doneImg)
        }
    }
    
    var doneImg: UIImage? {
        return self.done
        ? .check_Square_Img
        : .empty_Square_Img
    }
    
    func doneStatusChange_API() {
        // MARK: - API
    }
    
    var profileImg: UIImage? {
        return self.image == ""
        ? .person_Fill_Img
        : .x_Mark_Img
    }
    
    
    var doneStatusChanged: ((UIImage?) -> Void)?
    
    
    
    
    
    
    init(paymentDetail: PaymentDetail) {
        self.done = paymentDetail.done
        self.pay = paymentDetail.pay
        self.userID = paymentDetail.userID
        self.userName = paymentDetail.userName
        self.image = paymentDetail.userImg
        
    }
    
    
    
    
}
