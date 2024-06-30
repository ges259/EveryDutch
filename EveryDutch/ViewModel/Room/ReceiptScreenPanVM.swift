//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

final class ReceiptScreenPanVM: ReceiptScreenPanVMProtocol {
    
    /// 데이터 셀의 튜플 - (type: ReceiptCellEnum, detail: String?)
    private var dataCellTuple: [ReceiptCellTypeTuple] = []
    
    private var roomDataManager: RoomDataManagerProtocol
    private var receipt: Receipt
    
    
    
    var paymentDetailCountChanged: ((Bool) -> Void)?
    
    /// 유저 셀의 뷰모델
    private var userCellViewModels: [ReceiptScreenPanUsersCellVMProtocol] = []
    private var paymentDetailChanged: [PaymentDetail] = [] {
        didSet {
            dump(self.paymentDetailChanged)
            self.paymentDetailCountChanged?(self.paymentDetailChanged.count == 0)
        }
    }
    
    
    
    
    
    func changedUserPayback(at index: Int) {
        // 뷰모델의 done 값을 토글
        self.userCellViewModels[index].toggleDone()
        
        // 변경된 paymentDetail 가져오기
        let updatedPaymentDetail = self.userCellViewModels[index].getPaymentDetail
        
        // 변경된 paymentDetail이 이미 목록에 있는지 확인
        if let existingIndex = self.paymentDetailChanged.firstIndex(where: { $0.userID == updatedPaymentDetail.userID }) {
            // 이미 존재하면 목록에서 제거
            self.paymentDetailChanged.remove(at: existingIndex)
        } else {
            // 존재하지 않으면 목록에 추가
            self.paymentDetailChanged.append(updatedPaymentDetail)
        }
    }
    
    
    
    
    
    
    lazy var isMyReceipt: Bool = {
        return self.roomDataManager.myUserID == self.receipt.payer
    }()
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(receipt: Receipt,
         roomDataManager: RoomDataManagerProtocol) {
        self.receipt = receipt
        self.roomDataManager = roomDataManager
        
        self.makeDataCellData()
        self.makeUserCells()
    }
    
    
    
    // MARK: - 테이블뷰
    ///셀의 높이
    func getCellHeight(section: Int) -> CGFloat {
        switch section {
        case 0: return 45
        case 1: return 50
        default: return 0
        }
    }
    
    /// 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        switch section {
        case 0: return self.dataCellTuple.count
        case 1: return self.userCellViewModels.count
        default: return 0
        }
    }
    
    /// 섹션의 개수
    var getNumOfSection: Int {
        return 2
    }
    
    /// 헤더 타이틀
    func getHeaderTitle(section: Int) -> String {
        return section == 0
        ? "영수증"
        : "정산 내역"
    }
    
    /// 데이터 셀 반환
    func getCellData(index: Int) -> ReceiptCellTypeTuple {
        return self.dataCellTuple[index]
    }
    
    /// 셀의 뷰모델 반환
    func cellViewModel(at index: Int) -> ReceiptScreenPanUsersCellVMProtocol {
        return self.userCellViewModels[index]
    }
    
    
    // MARK: - 셀 생성
    /// 데이터 셀 데이터 설정
    private func makeDataCellData() {
        // Recipet데이터 변경
        let updatedReceipt = self.roomDataManager.updateReceiptUserName(receipt: self.receipt)
        self.dataCellTuple = ReceiptCellEnum.allCases.map { enumCase -> ReceiptCellTypeTuple in
            let detail = enumCase.detail(from: updatedReceipt)
            return (type: enumCase, detail: detail)
        }
    }
    
    /// 유저 셀 생성
    private func makeUserCells() {
        // Receipt에서 PaymentDetails 가져오기
        let paymentDetails = self.receipt.paymentDetails
                    
        // 셀 만들기
        self.userCellViewModels = paymentDetails.map { detail in
            let user = self.roomDataManager.getIdToUser(usersID: detail.userID)
            
            return ReceiptScreenPanUsersCellVM(
                roomUser: user,
                paymentDetail: detail)
        }
    }
}
