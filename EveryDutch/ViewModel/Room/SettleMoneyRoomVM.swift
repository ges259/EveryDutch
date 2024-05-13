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
    
    // MARK: - 인덱스패스 프로퍼티
    private var userDataManager: IndexPathDataManager<User> = IndexPathDataManager()
    private var receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    
    
    // MARK: - 탑뷰 프로퍼티
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
    /// 탑뷰 토글 (- 탑뷰가 현재 열려있는지 확인하는)
    var isTopViewOpen: Bool = false

    /// 탑뷰 크기 조절 변숫
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
    
    
    
   
    
    
    
    
    
    
//    var isSearchMode: Bool = false
//    
//    
//    var isTopViewBtnIsHidden: Bool {
//        return self.isSearchMode
//        ? true
//        : false
//    }
    var bottomBtnTitle: String {
        return "영수증 작성"
    }
    
    var navTitle: String? {
        return self.roomDataManager.getCurrentRoomName
    }
    
    
    

    
    
    
    // 정산내역 셀의 뷰모델
    
    
    // MARK: - 모델
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    
    
    
    
    // MARK: - 영수증 테이블뷰
    /// 영수증 개수
    var numberOfReceipt: Int {
        return self.roomDataManager.NumOfReceipts
    }
    /// 영수증 셀의 뷰모델 반환
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










// MARK: - 인덱스패스
extension SettleMoneyRoomVM {
    // 유저 데이터 인덱스패스
    func userDataChanged(_ userInfo: [String: [IndexPath]]) {
        self.userDataManager.dataChanged(userInfo)
    }

    func getPendingUserDataIndexPaths() -> [String: [IndexPath]] {
        return self.userDataManager.getPendingIndexPaths()
    }

    func resetPendingUserDataIndexPaths() {
        self.userDataManager.resetIndexPaths()
    }

    // 영수증 데이터 인덱스패스
    func receiptDataChanged(_ userInfo: [String: [IndexPath]]) {
        self.receiptDataManager.dataChanged(userInfo)
    }

    func getPendingReceiptIndexPaths() -> [String: [IndexPath]] {
        return self.receiptDataManager.getPendingIndexPaths()
    }

    func resetPendingReceiptIndexPaths() {
        self.receiptDataManager.resetIndexPaths()
    }
}
