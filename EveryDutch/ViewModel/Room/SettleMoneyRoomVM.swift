//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    // MARK: - 탑뷰의 높이
    /*
     인원 수에 따라 스택뷰의 maxHeight 크기 바꾸기
     - 바텀 앵커 : 35
     - 하단 버튼 : 45
     - 상단 레이아웃 : 35
     - 스택뷰 간격 : 10 -> 4
     - 네비게이션바 간격 : 12
     => 134
     - 인원 수 마다 크기: 40 - 최대 5명 (200)
     --------------- 결론 :  최대 크기 : 134 + 200 ---------------
     */
    /// 탑뷰의 최대 크기
    lazy var maxHeight: CGFloat = {
        let usersCount = self.roomDataManager.getNumOfRoomUsers
        // 셀당 40
        let tableHeight: Int = (usersCount * 40)
        // 테이블뷰의 최대 크기(200) + 나머지 크기(134)
        let totalHeight: Int = 134 + min(tableHeight, 200)
        return CGFloat(totalHeight)
    }()
    /// 탑뷰의 최소 크기
    let minHeight: CGFloat = 35
    

    
    
    // MARK: - 탑뷰 토글
    var isTopViewOpen: Bool = false
    
    var isSearchMode: Bool = false
    
    
    var isTopViewBtnIsHidden: Bool {
        return self.isSearchMode
        ? true
        : false
    }
    
    // MARK: - 탑뷰 크기 조절
    var initialHeight: CGFloat = 100
    var currentTranslation: CGPoint = .zero
    var currentVelocity: CGPoint = .zero
    
    var getMaxAndMinHeight: CGFloat {
        var height = self.initialHeight + currentTranslation.y
        // 새 높이가 최대 높이를 넘지 않도록 설정
        height = min(self.maxHeight, height)
        // 새 높이가 최소 높이보다 작아지지 않도록 설정
        height = max(self.minHeight, height)
        // flxjs
        return height
    }
    
    
    
    // MARK: - 레시피 개수
    var numberOfReceipt: Int {
        return self.cellViewModels.count
    }
    
    
    var bottomBtnTitle: String {
        return self.isSearchMode
        ? "검색 설정"
        : "영수증 작성"
    }
    
    var navTitle: String? {
        return self.isSearchMode
        ? "검색"
        : self.roomDataManager.getCurrentRoomName
    }
    
    
    
    
    
    // MARK: - 클로저
    var receiptChangedClosure: ((_ isFirst: Bool) -> Void)?
    var userChangedClosure: ((RoomUserDataDict) -> Void)?
    var fetchMoneyDataClosure: (() -> Void)?
    

    
    
    // MARK: - 셀의 뷰모델
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [SettleMoneyTableViewCellVM] = []
    
    // MARK: - 모델
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    /// 영수증 배열
    var receipts: [Receipt] = []
    
    
    
    
    // MARK: - 라이프 사이클
    init(receiptAPI: ReceiptAPIProtocol,
         roomDataManager: RoomDataManagerProtocol) {
        self.receiptAPI = receiptAPI
        self.roomDataManager = roomDataManager
        
        
        // api호출
        // 영수증 가져오기
        self.getUsersData()
        self.fetchRoomMoneyData()
    }
}
    
    

    
    
    

    
    
    
// MARK: - API

extension SettleMoneyRoomVM {
    
    // MARK: - 누적 금액 및 페이백 데이터 API
    private func fetchRoomMoneyData() {
        self.roomDataManager.loadPaybackData { [weak self] in
            self?.fetchMoneyDataClosure?()
        }
    }
    
    // MARK: - 유져 + 레시피 가져오기
    /// RoomDataManager에서 RoomUsers데이터 가져오기
    private func getUsersData() {
        
        self.roomDataManager.loadRoomUsers() { [weak self] roomusers in
            // 영수증 가져오기
            self?.fetchReceipt()
        }
    }
    
    // MARK: - 영수증 데이터 가져오기
    private func fetchReceipt() {
        // MARK: - Fix
        // 가져오기에 실패했을 때 코드 추가 필요
        guard let versionID = self.roomDataManager.getCurrentVersion else { return }
        
        
        self.receiptAPI.readReceipt(versionID: versionID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let receipts):
                self.makeCells(receipts: receipts)
                self.observingReceipt(versionID: versionID)
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
    }
    
    private func observingReceipt(versionID: String) {
        
    }
}
    
    
    
    
 





// MARK: - 셀 설정

extension SettleMoneyRoomVM {
    
    // MARK: - 셀 뷰모델 생성 및 업데이트
    private func createCellViewModel(receipt: Receipt) -> SettleMoneyTableViewCellVM {
        let payer = returnPayerData(payer: receipt.payer)
        return SettleMoneyTableViewCellVM(payer: payer, receiptData: receipt)
    }

    // MARK: - 모든 셀 만들기
    private func makeCells(receipts: [Receipt]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.cellViewModels = receipts.map { self.createCellViewModel(receipt: $0) }
            self.receipts = receipts
            self.receiptChangedClosure?(true)
        }
    }
    
    // MARK: - 새로운 셀 만들기
    func createOneCell(receipt: Receipt) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.receipts.insert(receipt, at: 0)
            
            let newCellVM = self.createCellViewModel(receipt: receipt)
            self.cellViewModels.insert(newCellVM, at: 0)
            self.receiptChangedClosure?(false)
        }
    }
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> SettleMoneyTableViewCellVM {
        return self.cellViewModels[index]
    }
    
    // MARK: - 유저 이름 반환
    private func returnPayerData(payer: String) -> String {
        // 유저 데이터 가져오기
        let payerData = self.roomDataManager.getIdToRoomUser(usersID: payer)
        // 유저 이름 반환
        return payerData.roomUserName
    }
}
