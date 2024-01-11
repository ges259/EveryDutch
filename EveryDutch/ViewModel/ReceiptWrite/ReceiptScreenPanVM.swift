//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

struct ReceiptScreenPanVM {
    
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [SettlementTableViewCellVM] = []
    
    var receipt: Receipt
    
//    var users
    
    init(receipt: Receipt) {
        self.receipt = receipt
    }
}
