//
//  UserProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import UIKit

final class UserProfileVM: UserProfileVMProtocol {
    
    // MARK: - 플래그
    private var _hasMoreUserReceiptData: Bool = true
    private var _hasNoData: Bool = false
    private var _isTableOpen: Bool = false {
        didSet {
            self.updateSearchMode()
        }
    }

    
    
    // MARK: - 클로저
    var fetchSuccessClosure: (([IndexPath]) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    var searchModeClosure: ((UIImage?, String) -> Void)?
    
    
    
    private let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
    }
    deinit {
        print("\(#function) ----- \(self)")
        self.roomDataManager.resetUserReceipt()
    }
    
    
    
    
    
    
    
    
    // MARK: - 플래그 변경
    func disableMoreUserReceiptDataLoading() {
        self._hasMoreUserReceiptData = false
    }
    
    func markNoDataAvailable() {
        self._hasNoData = true
    }
    
    func setTableOpenState(_ isOpen: Bool) {
        self._isTableOpen = isOpen
    }
    
    
    
    // MARK: - 데이터 리턴
    var isTableOpen: Bool {
        return self._isTableOpen
    }
    
    var hasNoData: Bool {
        return self._hasNoData
    }
    
    var getUserReceiptLoadSuccess: Bool {
        self.roomDataManager.getUserReceiptLoadSuccess
    }
    /// 방장인지 확인하는 변수
    lazy var isRoomManager: Bool = {
        return self.roomDataManager.checkIsRoomManager
    }()
    /// 유저의 정보를 리턴하는 변수
    var getUserDecoTuple: UserDecoTuple? {
        return self.roomDataManager.getCurrentUserData
    }
    /// 버튼의 이미지 및 타이틀을 클로저를 통해 리턴
    private func updateSearchMode() {
        let image: UIImage? = self._isTableOpen ? .chevronBottom : .search_Img
        let title = self._isTableOpen ? "취소" : "검색"
        self.searchModeClosure?(image, title)
    }
    
    
    
    // MARK: - 테이블뷰
    /// 영수증의 개수 == 셀의 개수
    var numberOfReceipt: Int {
        return self.roomDataManager.getNumOfUserReceipts
    }
    /// cellForRowAt에서 필요한 셀의 뷰모델을 리턴
    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol {
        return self.roomDataManager.getUserReceiptViewModel(index: index)
    }
    /// 셀 선택 시, 영수증 정보를 리턴하는 메서드
    func getReceipt(at index: Int) -> Receipt {
        return self.roomDataManager.getUserReceipt(at: index)
    }
}










// MARK: - API
extension UserProfileVM {
    /// 영수증 데이터를 가져오는 메서드
    func loadUserReceipt() {
        guard self._hasMoreUserReceiptData else {
            self.errorClosure?(.noMoreData)
            return
        }
        
        print(#function)
        
        self.roomDataManager.fetchUserReceipt { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let indexPaths):
                self.fetchSuccessClosure?(indexPaths)
                
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
    
    ///
    func reportUser() {
        
    }
    
    func kickUser() {
        
    }
}
