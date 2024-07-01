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
    
    var getDone: Bool {
        return self.paymentDetail.done
    }
    
    
    var getPaymentDetail: PaymentDetail {
        return self.paymentDetail
    }

    
    init(roomUser: User?,
         paymentDetail: PaymentDetail) {
        self.user = roomUser
        self.paymentDetail = paymentDetail
    }

    
    
    

    mutating func toggleDone() {
        print("\(#function) ----- 1")
        self.paymentDetail.done.toggle()
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
