//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

struct ReceiptScreenPanVM: ReceiptScreenPanVMProtocol {
    
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [ReceiptScreenPanUsersCellVM] = []
    
    private var receipt: Receipt
    private var roomDataManager: RoomDataManagerProtocol
    
    
    
    
    
    var currentNumOfUsers: Int = 0
//    {
//        return self.cellViewModels.count
//    }
    
    

    
    
    
    
    var getReceipt: Receipt {
        return self.receipt
    }
    var getPayerName: String {
        let payer = self.receipt.payer
        let payerName = self.roomDataManager.getIdToRoomUser(
            usersID: payer)
        return payerName.roomUserName
    }
    
    var getPayMethod: String {
        return self.receipt.paymentMethod == 1
        ? "1 / N"
        : "사용자 지정"
    }
    
    
    
    
    
    
    
    // ****************************************

    
    // MARK: - [영수증] 배열
    private let receiptCell: [ReceiptEnum] = ReceiptEnum.allCases
    
    
    // MARK: - 배열 반환
    func getReceiptEnum(index: Int) -> ReceiptEnum {
        return self.receiptCell[index]
    }
    
    
    
    // MARK: - 이미지 반환
    func getCellImg(section: Int) -> UIImage? {
        return self.receiptCell[section].img
    }
    
    // MARK: - 디테일 텍스트
    func getCellText(section: Int) -> String {
        return self.receiptCell[section].text
    }
    
    
    
    
    
    // MARK: - [공통] 셀의 높이
    func getCellHeight(section: Int) -> CGFloat {
        return section == 1
        ? 50
        : 45
    }
    
    // MARK: - [공통] 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        return section == 1
        ? self.currentNumOfUsers
        : self.self.receiptCell.count
    }
    
    // MARK: - [공통] 섹션의 개수
    var getNumOfSection: Int {
        return 2
    }
    
    // MARK: - [공통] 헤더 타이틀
    func getHeaderTitle(section: Int) -> String {
        return section == 1
        ? "정산 내역"
        : "영수증"
    }
    
    
    
    // ****************************************
    
    
    
    // MARK: - 라이프사이클
    init(receipt: Receipt,
         roomDataManager: RoomDataManagerProtocol) {
        self.receipt = receipt
        self.roomDataManager = roomDataManager
        
        self.makeCells()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 셀 생성
    mutating func makeCells() {
        // Receipt에서 PaymentDetails 가져오기
        let paymentDetails = receipt.paymentDetails
        
        // usersTableView 셀의 개수 저장
        self.currentNumOfUsers = paymentDetails.count
                    
        // 셀 만들기
        
        self.cellViewModels = paymentDetails.map { detail in
            let user = self.roomDataManager.getIdToRoomUser(
                usersID: detail.userID)
            
            return ReceiptScreenPanUsersCellVM(
                roomUser: user,
                paymentDetail: detail)
        }
    }
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptScreenPanUsersCellVM {
        return self.cellViewModels[index]
    }
}
