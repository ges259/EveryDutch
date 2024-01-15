//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    // 정산내역 셀의 뷰모델
    private var cellViewModels: [SettleMoneyTableViewCellVM] = []

    
    
    // MARK: - 클로저
    var receiptChangedClosure: (() -> Void)?
    var userChangedClosure: ((RoomUserDataDictionary) -> Void)?
    var fetchMoneyDataClosure: (([MoneyData]) -> Void)?
    
    
    
    

    
    
    
    /// 영수증 배열
    var receipts: [Receipt] = [] {
        didSet {
            self.receiptChangedClosure?()
        }
    }
    /// 방의 유저 데이터
    var roomUser: RoomUserDataDictionary = [:]
    
    var roomMoneyData: [MoneyData] = [] {
        didSet {
            self.fetchMoneyDataClosure?(self.roomMoneyData)
        }
    }
    
    
    var topViewIsOpen: Bool = false
    
    
    
    
    
    // MARK: - 탑뷰 높이
    let minHeight: CGFloat = 35
    /**
     인원 수에 따라 스택뷰의 maxHeight 크기 바꾸기
     - 바텀 앵커 : 35
     - 하단 버튼 : 45
     - 상단 레이아웃 : 35
     - 스택뷰 간격 : 10 -> 4
     - 네비게이션바 간격 : 12
     => 134
     - 인원 수 마다 크기: 40 - 최대 5명 (200)
     
     결론 :  최대 크기 : 134 + 200
     */
    lazy var maxHeight: CGFloat = {
        let tableHeight: Int = (self.roomUser.count * 40)
        let totalHeight: Int = 134 + min(tableHeight, 200)
        return CGFloat(totalHeight)
    }()
    
    
    
    
    // MARK: - 레시피 개수
    var numberOfReceipt: Int {
        return self.cellViewModels.count
    }
    
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
        self.fetchReceipt()
        self.fetchUsers()
        self.fetchRoomMoneyData()
    }
    
    
    

    
    
    
    
    
    
    // MARK: - API
    /// 영수증 데이터 가져오기
    private func fetchReceipt() {
        self.receiptAPI.readReceipt { result in
            switch result {
            case .success(let receipts):
                self.cellViewModels = receipts.map({ receipt in
                    SettleMoneyTableViewCellVM(receiptData: receipt)
                })
                self.receipts = receipts
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
    }
    /// 누적 금액 가져오기
    private func fetchRoomMoneyData() {
        self.roomDataManager.loadRoomMoneyData { moneyData in
            self.roomMoneyData = moneyData
        }
    }
    /// RoomDataManager에서 RoomUsers데이터 가져오기
    private func fetchUsers() {
        self.roomDataManager.loadRoomUsers(roomData: self.roomData) { roomusers in
            self.roomUser = roomusers
        }
    }
    
    
    
    
    // MARK: - 셀 뷰모델 설정
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> SettleMoneyTableViewCellVM {
        return self.cellViewModels[index]
    }
    
    
    deinit {
        print("------------------------------------------------------------")
    }
}
