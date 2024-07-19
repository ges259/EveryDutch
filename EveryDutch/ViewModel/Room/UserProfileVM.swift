//
//  UserProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import UIKit

final class UserProfileVM: UserProfileVMProtocol {
    
 
    
    
    // MARK: - 플래그
    /// 데이터가 추가적으로 있는지 확인하는 플래그
    /// false라면, loadMoreUserReceipt을 호출하지 않음
    private var _hasMoreUserReceiptData: Bool = true
    /// '데이터가 아예 없다'라는 것을 나타내는 플래그
    /// false라면, NoDataView를 띄움
    private var _hasNoData: Bool = false
    /// 첫 번째 로드 성공 여부 플래그
    private var _userReceiptInitialLoad: Bool = false
    /// searchBtn을 눌러 화면이 전환을 나타내는 플래그
    private var _isTableOpen: Bool = false {
        didSet { self.updateSearchMode() }
    }
    var userReceiptInitialLoad: Bool {
        return self._userReceiptInitialLoad
    }
    
    
    
    
    
    
    // MARK: - 클로저
    var deleteUserSuccessClosure: (() -> Void)?
    var reportSuccessClosure: ((AlertEnum, Int) -> Void)?
    var searchModeClosure: ((UIImage?, String) -> Void)?
    
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    // 모델
    private let receiptAPI: ReceiptAPIProtocol
    private let roomsAPI: RoomsAPIProtocol
    private let roomDataManager: RoomDataManagerProtocol
    
    /// 유저 검색 시, 유저의 영수증 테이블 셀의 뷰모델
    var receiptSections = [ReceiptSection]()
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         receiptAPI: ReceiptAPIProtocol,
         roomsAPI: RoomsAPIProtocol
    ) {
        self.roomDataManager = roomDataManager
        self.receiptAPI = receiptAPI
        self.roomsAPI = roomsAPI
    }
    deinit {
        print("\(#function) ----- \(self)")
        self.receiptAPI.resetUserReceiptKey()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 플래그 변경
    /// '더이상 가져올 데이터가 없다'라고 플래그 표시
    func disableMoreUserReceiptDataLoading() {
        self._hasMoreUserReceiptData = false
    }
    /// '데이터가 아예 없다'라고 표시하는 플래그
    func markNoDataAvailable() {
        self._hasNoData = true
    }
    /// CardImgView
    func setTableOpenState(_ isOpen: Bool) {
        self._isTableOpen = isOpen
    }
    
    
    
    // MARK: - 데이터 리턴
    var hasNoData: Bool {
        return self._hasNoData
    }
    var isTableOpen: Bool {
        return self._isTableOpen
    }
    
    /// 자신이 방장인지 Bool값을 리턴
    lazy var isRoomManager: Bool = {
        return self.roomDataManager.checkIsRoomManager
    }()
    
    /// 현재 사용자가 자기 자신인지 Bool값을 리턴
    lazy var currentUserIsEuqualToMyUid: Bool = {
        return self.roomDataManager.currentUserIsEuqualToMyUid
    }()
    
    /// 유저의 정보(User, Decoration)를 리턴하는 변수
    var getUserDecoTuple: UserDecoTuple? {
        return self.roomDataManager.getCurrentUserData
    }
    /// 버튼의 이미지 및 타이틀을 클로저를 통해 리턴
    private func updateSearchMode() {
        let image: UIImage? = self._isTableOpen ? .chevronBottom : .search_Img
        let title = self._isTableOpen ? "취소" : "검색"
        self.searchModeClosure?(image, title)
    }
}










// MARK: - API
extension UserProfileVM {
    
    /// 특정 유저를 신고하는 메서드
    func reportUser() {
        guard let roomID = self.roomDataManager.getCurrentRoomsID,
              let userID = self.roomDataManager.getSelectedUserID
        else {
            self.errorClosure?(.readError)
            return
        }
        
        self.roomsAPI.reportUser(
            roomID: roomID,
            reportedUserID: userID
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let reportCount):
                self.handleReportCount(reportCount)
                
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
    
    /// 신고 횟수를 처리하는 메서드
    private func handleReportCount(_ reportCount: Int) {
        if reportCount >= 3 {
            // reportCount가 3이상이라면, 유저 강퇴
            self.deleterUserFromRoom {
                self.reportSuccessClosure?(AlertEnum.reportAndKickSuccess, reportCount)
            }
            
            
        } else {
            // reportCount가 3 미만일 때 수행할 액션 (여기에 추가할 로직이 있다면 작성)
            self.reportSuccessClosure?(AlertEnum.reportSuccess, reportCount)
        }
    }
    
    /// '방장'이 특정 유저를 강퇴시키는 메서드
    func kickUser() {
        self.deleterUserFromRoom(successClosure: self.deleteUserSuccessClosure)
    }
    
    private func deleterUserFromRoom(
        successClosure: (() -> Void)?
    ) {
        self.roomDataManager.deleteUserFromRoom(
            isDeletingSelf: false, 
            isRoomManager: false
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                // 뒤로가기
                successClosure?()
                break
                
            case .failure(_):
                self.errorClosure?(.readError)
            }
        }
    }
    
    
    // MARK: - 영수증 데이터
    func loadReceiptData() {
        self.roomDataManager.loadUserReceipt()
    }
    
    func loadMoreReceiptData() {
        self.roomDataManager.loadMoreUserReceipt()
    }
}
