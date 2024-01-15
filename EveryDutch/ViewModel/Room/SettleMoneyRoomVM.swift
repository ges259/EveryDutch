//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    /// 영수증 배열
    var receipts: [Receipt] = [] {
        didSet { self.receiptChangedClosure?() }
    }
    /// 방의 유저 데이터
    var roomUser: RoomUserDataDictionary = [:]
    
    var roomMoneyData: [MoneyData] = [] {
        didSet { self.fetchMoneyDataClosure?(self.roomMoneyData) }
    }
    
    
    var topViewIsOpen: Bool = false
    
    
    
    
    
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
        // 셀당 40
        let tableHeight: Int = (self.roomUser.count * 40)
        // 테이블뷰의 최대 크기(200) + 나머지 크기(134)
        let totalHeight: Int = 134 + min(tableHeight, 200)
        return CGFloat(totalHeight)
    }()
    /// 탑뷰의 최소 크기
    let minHeight: CGFloat = 35
    
    
    
    // MARK: - 레시피 개수
    var numberOfReceipt: Int {
        return self.cellViewModels.count
    }
    
    
    
    // MARK: - 클로저
    var receiptChangedClosure: (() -> Void)?
    var userChangedClosure: ((RoomUserDataDictionary) -> Void)?
    var fetchMoneyDataClosure: (([MoneyData]) -> Void)?
    
    
    
    // MARK: - 셀의 뷰모델
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [SettleMoneyTableViewCellVM] = []
    
    // MARK: - 모델
    /// 방의 데이터
    private var roomData: Rooms
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol

    
    // MARK: - 라이프 사이클
    init(roomData: Rooms,
         receiptAPI: ReceiptAPIProtocol,
         roomDataManager: RoomDataManagerProtocol) {
        self.receiptAPI = receiptAPI
        self.roomData = roomData
        self.roomDataManager = roomDataManager
        // api호출
        // 영수증 가져오기
        self.fetchUsers()
        self.fetchRoomMoneyData()
    }
    deinit {
        print("------------------------------------------------------------")
    }
}
    
    

    
    
    
    
    
    
// MARK: - API

extension SettleMoneyRoomVM {
    
    // MARK: - 누적 금액 가져오기
    /// 누적 금액 가져오기
    private func fetchRoomMoneyData() {
        self.roomDataManager.loadRoomMoneyData { moneyData in
            self.roomMoneyData = moneyData
        }
    }
    // MARK: - 유져 + 레시피 가져오기
    /// RoomDataManager에서 RoomUsers데이터 가져오기
    private func fetchUsers() {
        self.roomDataManager.loadRoomUsers(roomData: self.roomData) { roomusers in
            self.roomUser = roomusers
            
            // 영수증 가져오기
            self.fetchReceipt()
        }
    }
    // MARK: - 영수증 데이터 가져오기
    private func fetchReceipt() {
        self.receiptAPI.readReceipt { result in
            switch result {
            case .success(let receipts):
                self.makeCell(receipts: receipts)
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
    }
}
    
    
    
    
 





// MARK: - 셀 설정

extension SettleMoneyRoomVM {
    
    // MARK: - 셀 만들기
    private func makeCell(receipts: [Receipt]) {
        self.cellViewModels = receipts.map({ receipt in
            
            let payer = receipt.payer
            let payerData = self.roomDataManager.getIdToroomUser(usersID: payer)
            
            return SettleMoneyTableViewCellVM(
                payer: payerData.roomUserName,
                receiptData: receipt)
        })
        self.receipts = receipts
    }
    
    // MARK: - 셀 뷰모델 설정
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> SettleMoneyTableViewCellVM {
        return self.cellViewModels[index]
    }
}
