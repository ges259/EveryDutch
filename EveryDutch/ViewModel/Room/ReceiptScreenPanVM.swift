//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

struct ReceiptScreenPanVM: ReceiptScreenPanVMProtocol {
    
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [ReceiptScreenPanCellVM] = []
    
    var receipt: Receipt
    var roomDataManager: RoomDataManager
    
    var currentNumOfUsers: Int = 0
    
    // MARK: - 라이프사이클
    init(receipt: Receipt,
         roomDataManager: RoomDataManager) {
        self.receipt = receipt
        self.roomDataManager = roomDataManager
        
        self.makeCells()
    }
    
    
    // MARK: - 셀 생성
    mutating func makeCells() {
        // Receipt에서 PaymentDetails 가져오기
        let paymentDetails = receipt.paymentDetails
        
        // RoomDataManager의 인스턴스를 사용하여 PaymentDetail 업데이트
        let updated = self.roomDataManager.updatePaymentDetails(
            paymentDetails: paymentDetails)
        
        // usersTableView 셀의 개수 저장
        self.currentNumOfUsers = updated.count
        
        // 셀 만들기
        self.cellViewModels = updated.map { detail in
            ReceiptScreenPanCellVM(paymentDetail: detail)
        }
    }
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptScreenPanCellVM {
        return self.cellViewModels[index]
    }
}
