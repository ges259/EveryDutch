//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


final class IndexPathDataManager<T> {
    private var indexPaths: [String: [IndexPath]] = [:]

    func dataChanged(_ userInfo: [String: [IndexPath]]) {
        self.indexPaths.merge(userInfo) { _, new in new }
    }

    func getPendingIndexPaths() -> [String: [IndexPath]] {
        return self.indexPaths
    }

    func resetIndexPaths() {
        self.indexPaths.removeAll()
    }
}


final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    private var userDataManager: IndexPathDataManager<User> = IndexPathDataManager()
    private var receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()

    // User data handling
    func userDataChanged(_ userInfo: [String: [IndexPath]]) {
        userDataManager.dataChanged(userInfo)
    }

    func getPendingUserDataIndexPaths() -> [String: [IndexPath]] {
        return userDataManager.getPendingIndexPaths()
    }

    func resetPendingUserDataIndexPaths() {
        userDataManager.resetIndexPaths()
    }

    // Receipt data handling
    func receiptDataChanged(_ userInfo: [String: [IndexPath]]) {
        receiptDataManager.dataChanged(userInfo)
    }

    func getPendingReceiptIndexPaths() -> [String: [IndexPath]] {
        return receiptDataManager.getPendingIndexPaths()
    }

    func resetPendingReceiptIndexPaths() {
        receiptDataManager.resetIndexPaths()
    }
    
    
    
    
    
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
    var maxHeight: CGFloat {
        let usersCount = self.roomDataManager.getNumOfRoomUsers
        // 셀당 40
        let tableHeight: Int = (usersCount * 40)
        // 테이블뷰의 최대 크기(200) + 나머지 크기(134)
        let totalHeight: Int = 134 + min(tableHeight, 200)
        return CGFloat(totalHeight)
    }
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
    
    
    

    
    
    // MARK: - 셀의 뷰모델
    // 정산내역 셀의 뷰모델
    
    
    // MARK: - 모델
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    
    
    // MARK: - 레시피 개수
    var numberOfReceipt: Int {
        return self.roomDataManager.NumOfReceipts
    }
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol {
        return self.roomDataManager.getReceiptViewModel(index: index)
    }
    
    
    // MARK: - 라이프 사이클
    init(receiptAPI: ReceiptAPIProtocol,
         roomDataManager: RoomDataManagerProtocol) {
        self.receiptAPI = receiptAPI
        self.roomDataManager = roomDataManager
        
        // api호출
        self.roomDataManager.startLoadRoomData()
    }
    deinit { self.roomDataManager.removeRoomsUsersObserver() }
}
