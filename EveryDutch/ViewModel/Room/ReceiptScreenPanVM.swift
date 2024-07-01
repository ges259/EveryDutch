//
//  ReceiptScreenPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

final class ReceiptScreenPanVM: ReceiptScreenPanVMProtocol {
    
    // MARK: - 모델
    /// 데이터 셀의 튜플 - (type: ReceiptCellEnum, detail: String?)
    private var dataCellTuple: [ReceiptCellTypeTuple] = []
    /// 유저 셀의 뷰모델
    private var userCellViewModels: [ReceiptScreenPanUsersCellVMProtocol] = []
    
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    private var receipt: Receipt
    
    
    /// 바뀐 PaymentDetail의 데이터를 저장하는 배열
    private var paymentDetailChanged: [PaymentDetail] = [] {
        didSet {
            dump(self.paymentDetailChanged)
            self.paymentDetailCountChanged?(self.paymentDetailChanged.count == 0)
        }
    }
    
    // MARK: - 클로저
    /// 선택된 유저의 수가 바뀌면 호출되는 클로저
    var paymentDetailCountChanged: ((Bool) -> Void)?
    
    
    /// 자신이 영수증의 payer(계산한 사람)인지를 판단하는 변수
    lazy var isMyReceipt: Bool = {
        return self.roomDataManager.myUserID == self.receipt.payer
    }()
    
    
    
    
    
    // MARK: - 라이프사이클
    init(receipt: Receipt,
         receiptAPI: ReceiptAPIProtocol,
         roomDataManager: RoomDataManagerProtocol
    ) {
        self.receipt = receipt
        self.receiptAPI = receiptAPI
        self.roomDataManager = roomDataManager
        
        self.makeDataCellData()
        self.makeUserCells()
    }
}










// MARK: - PaymetDetail 변경
extension ReceiptScreenPanVM {
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
}










// MARK: - 테이블뷰
extension ReceiptScreenPanVM {
    /// 셀의 높이
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
}










// MARK: - 셀 생성
extension ReceiptScreenPanVM {
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










// MARK: - API
extension ReceiptScreenPanVM {
    // 결제 세부 데이터를 업데이트하는 메서드
    // 현재 버전 ID를 가져오고, 각 사용자의 결제 완료 상태를 포함한 데이터를 서버에 업데이트
    // 성공 시 paymentDetailChanged 배열을 초기화
    func updatePaymentDetailData() {
        Task {
            do {
                guard let versionID = self.roomDataManager.getCurrentVersion else { return }
                
                // 결제 세부 데이터 업데이트
                try await self.updatePaymentDetail(versionID: versionID)
                // 결제 환급 데이터 업데이트
                try await self.updatePayback(versionID: versionID)
                // 모든 사용자의 결제 완료 상태를 확인하여, 모두 true일 경우 영수증 타입을 업데이트
                try await self.updateReceiptTypeIfNeeded(versionID: versionID)
                // 유저의 usersReceipts 
                try await self.updateUserReceipts(versionID: versionID)
                
                DispatchQueue.main.async {
                    print("\(#function) ----- Success")
                    // 성공했다면,paymentDetailChanged를 초기화
                    self.paymentDetailChanged = []
                }
            } catch {
                print("\(#function) ----- Fail")
            }
        }
    }
    
    
    
    // MARK: - UsersReceipts 업데이트
    private func updateUserReceipts(versionID: String) async throws {
        let dict = self.paymentDetailChanged.reduce(into: [String: Bool]()) { result, detail in
            return result[detail.userID] = detail.done
        }
        
        try await self.receiptAPI.saveReceiptForUsers(
            versionID: versionID,
            receiptID: self.receipt.receiptID,
            dict: dict
        )
    }
    
    
    
    // MARK: - PaymentDetail 업데이트
    /// 결제 세부 데이터를 업데이트하는 비동기 메서드
    /// versionID에 해당하는 버전의 영수증에서 결제 세부 데이터를 업데이트
    private func updatePaymentDetail(versionID: String) async throws {
        let paymentDetailsDict = self.reducePaymentDetailsDict()
        
        try await self.receiptAPI.updatePaymentDetail(
            versionID: versionID,
            receiptID: self.receipt.receiptID,
            paymentDetailsDict: paymentDetailsDict)
    }
    /// paymentDetailChanged 배열에서 사용자별 결제 세부 데이터를 줄이는 메서드
    /// 각 사용자의 userID를 키로 하고, 결제 금액(pay)과 완료 여부(done)를 값으로 하는 딕셔너리를 생성
    private func reducePaymentDetailsDict() -> [String : [String: Any]] {
        return self.paymentDetailChanged.reduce(into: [String: [String: Any]]()) { result, detail in
            
            return result[detail.userID] = [
                DatabaseConstants.pay  : detail.pay,
                DatabaseConstants.done : detail.done
            ]
        }
    }
    
    
    
    // MARK: - 페이백 업데이트
    /// 결제 환급 데이터를 업데이트하는 비동기 메서드
    /// versionID에 해당하는 버전의 영수증에서 결제 환급 데이터를 업데이트
    private func updatePayback(versionID: String) async throws {
        let paybackDict = self.createPaybackDict()
        
        try await self.receiptAPI.updatePayback(
            versionID: versionID,
            payerID: self.receipt.payer,
            moneyDict: paybackDict
        )
    }
    /// 현재 결제 상세 정보를 기반으로 각 사용자별 환급 금액을 나타내는 딕셔너리를 생성후 리턴
    private func createPaybackDict() -> [String: Int] {
        var paybackDict = [String: Int]()
        
        for detail in self.paymentDetailChanged {
            let amount = detail.done ? -detail.pay : detail.pay
            paybackDict[detail.userID] = amount
        }
        
        return paybackDict
    }
    
    
    
    // MARK: - 타입 업데이트
    /// 결제 완료 상태에 따라 영수증 타입을 업데이트하는 비동기 메서드
    /// 모든 사용자의 결제 완료 상태(done)를 확인하고, 모든 사용자가 완료 상태일 경우 newType을 1로 업데이트
    /// 그렇지 않으면 newType을 0으로 업데이트
    private func updateReceiptTypeIfNeeded(
        versionID: String
    ) async throws {
        let allDone = self.userCellViewModels.allSatisfy { $0.getDone }
        let newType = allDone ? 1 : 0
        
        try await self.receiptAPI.updateReceiptType(
            versionID: versionID,
            receiptID: self.receipt.receiptID,
            newType: newType
        )
    }
}
