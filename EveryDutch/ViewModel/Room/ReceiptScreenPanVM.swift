//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

final class ReceiptScreenPanVM: ReceiptScreenPanVMProtocol {
    
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [ReceiptScreenPanUsersCellVM] = []
    /// 데이터 셀의 데이터
    /// (type: ReceiptCellEnum, detail: String?)
    private var dataCellData: [ReceiptCellTypeTuple] = []
    
    
    
    private var roomDataManager: RoomDataManagerProtocol
    
    
    private var receipt: Receipt
    
    
    
    
    
    
    
    

    
    

    
    
    
    
    var getPayMethod: String {
        return self.receipt.paymentMethod == 1
        ? "1 / N"
        : "사용자 지정"
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - [공통] 셀의 높이
    func getCellHeight(section: Int) -> CGFloat {
        switch section {
        case 0: return 45
        case 1: return 50
        default: return 0
        }
    }
    
    // MARK: - [공통] 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        switch section {
        case 0: return self.dataCellData.count
        case 1: return self.cellViewModels.count
        default: return 0
        }
    }
    
    // MARK: - [공통] 섹션의 개수
    var getNumOfSection: Int {
        return 2
    }
    
    // MARK: - [공통] 헤더 타이틀
    func getHeaderTitle(section: Int) -> String {
        return section == 0
        ? "영수증"
        : "정산 내역"
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(receipt: Receipt,
         roomDataManager: RoomDataManagerProtocol) {
        self.receipt = receipt
        self.roomDataManager = roomDataManager
        
        self.makeUserCells()
        self.makeDataCellData()
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 데이터 셀 데이터 설정
    private func makeDataCellData() {
        // Recipet데이터 변경
        let payerName = self.roomDataManager.getIdToRoomUser(usersID: self.receipt.payer)
        self.receipt.updatePayerName(with: payerName)
        
        self.dataCellData = ReceiptCellEnum.allCases.map { enumCase -> ReceiptCellTypeTuple in
            let detail = enumCase.detail(from: self.receipt)
            return (type: enumCase, detail: detail)
        }
    }
    
    // MARK: - 유저 셀 생성
    private func makeUserCells() {
        // Receipt에서 PaymentDetails 가져오기
        let paymentDetails = self.receipt.paymentDetails
                    
        // 셀 만들기
        self.cellViewModels = paymentDetails.map { detail in
            let user = self.roomDataManager.getIdToRoomUser(usersID: detail.userID)
            
            return ReceiptScreenPanUsersCellVM(
                roomUser: user,
                paymentDetail: detail)
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 데이터 셀 반환
    func getCellData(index: Int) -> ReceiptCellTypeTuple {
        return self.dataCellData[index]
    }
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptScreenPanUsersCellVM {
        return self.cellViewModels[index]
    }
}
