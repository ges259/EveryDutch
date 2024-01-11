//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

struct ReceiptScreenPanVM {
    
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [ReceiptScreenPanCellVM] = []
    
    var receipt: Receipt
    
    lazy var dd = receipt.paymentDetails
    
    init(receipt: Receipt) {
        self.receipt = receipt
        self.makeCells()
    }
    
    
    mutating func makeCells() {
        let details = self.receipt.paymentDetails
        
        self.cellViewModels = details.map { detail in
            ReceiptScreenPanCellVM(paymentDetail: detail)
        }
    }
}
