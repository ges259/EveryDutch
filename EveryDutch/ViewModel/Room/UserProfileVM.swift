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
    
    
    
    private var _changedIndexPaths: [String: [IndexPath]] = [:]
    
    
    
    // MARK: - 클로저
    var fetchSuccessClosure: (() -> Void)?
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
        self._userReceiptInitialLoad = true
    }
    /// CardImgView
    func setTableOpenState(_ isOpen: Bool) {
        self._isTableOpen = isOpen
    }
    /// 초기 데이터를 가져왔다는 표시
    func userReceiptInitialLoadSetTrue() {
        self._userReceiptInitialLoad = true
    }
    
    
    
    // MARK: - 데이터 리턴
    var hasNoData: Bool {
        return self._hasNoData
    }
    var userReceiptInitialLoad: Bool {
        return self._userReceiptInitialLoad
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










// MARK: - 테이블뷰
extension UserProfileVM {
    /// 섹션의 개수
    var numOfSections: Int {
        return self.receiptSections.count
    }
    /// 영수증 개수
    func numOfReceipts(section: Int) -> Int {
        return self.receiptSections[section].receipts.count
    }
    /// 영수증 셀(ReceiptTableViewCellVMProtocol) 리턴
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol{
        var receiptVM = self.receiptSections[indexPath.section].receipts[indexPath.row]
        
        let updatedReceipt = self.roomDataManager.updateReceiptUserName(receipt: receiptVM.getReceipt)
        receiptVM.setReceipt(updatedReceipt)
        
        return receiptVM
    }
    /// index를 받아 알맞는 영수증을 리턴
    func getReceipt(at indexPath: IndexPath) -> Receipt {
        return self.receiptSections[indexPath.section].receipts[indexPath.row].getReceipt
    }
    
    /// 섹션 헤더의 타이틀(날짜)를 리턴
    func getReceiptSectionDate(section: Int) -> String {
        return self.receiptSections[section].date
    }
}










// MARK: - API
extension UserProfileVM {
    
    /// 특정 유저를 신고하는 메서드
    func reportUser() {
        guard let roomID = self.roomDataManager.getCurrentRoomsID,
              let userID = self.roomDataManager.getCurrentUserID
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
            isDeletingSelf: false
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
}










// MARK: - 영수증 가져오기
extension UserProfileVM {
    /// 사용자의 영수증을 가져오는 함수
    /// 초기 로드 시 검색 모드로 전환하고 영수증을 가져옴
    func loadUserReceipt() {
        guard self._hasMoreUserReceiptData else {
            self.errorClosure?(.noMoreData)
            return
        }
        
        print(#function)
        // 영수증 데이터를 가져옴
        self.fetchReceipts()
    }
    
    /// 영수증 데이터를 가져오는 함수
    /// completion 핸들러를 통해 결과를 반환
    private func fetchReceipts() {
        print(#function)
        // 버전ID 및 현재 유저ID 가져오기
        // 만약 버전ID나 유저ID를 가져오지 못하면 읽기 오류를 반환하고 종료
        guard let versionID = self.roomDataManager.getCurrentVersion,
              let userID = self.roomDataManager.getCurrentUserID else {
            self.errorClosure?(.readError)
            return
        }
        
        // firstLoadSuccess 플래그를 기반으로 초기 로드 함수 또는 추가 로드 함수를 선택
        // 첫 번째 매개변수: userID
        // 두 번째 매개변수: versionID
        // 세 변째 매개변수: Result<[ReceiptTuple], ErrorEnum>타입의 결과를 반환하는 클로저
        let fetchFunction: (
            String,
            String,
            @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
        ) -> Void
        // !self.firstLoadSuccess가 true인지 false인지 판단
        = !self._userReceiptInitialLoad
        // !self.firstLoadSuccess의 결과에 따라 fetchFunction에 다른 함수 저장
        ? self.receiptAPI.loadInitialUserReceipts
        : self.receiptAPI.loadMoreUserReceipts
        
        // 비동기적으로 영수증 데이터를 가져옴
        DispatchQueue.global(qos: .utility).async {
            fetchFunction(userID, versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let load):
                    // 영수증 데이터를 성공적으로 가져옴
                    print("영수증 가져오기 성공")
                    self.handleAddedReceiptEvent(load)
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("영수증 가져오기 실패")
                        // 영수증 데이터를 가져오지 못한 경우 오류를 반환
                        self.errorClosure?(error)
                    }
                }
            }
        }
    }
    
    
    func getPendingSections() -> [String: [Int]] {
        var sectionDict: [String: [Int]] = [:]
        for (key, indexPaths) in _changedIndexPaths {
            let sections = Set(indexPaths.map { $0.section }).sorted()
            sectionDict[key] = sections
        }
        return sectionDict
    }

    func resetIndexPaths() {
        _changedIndexPaths.removeAll()
    }
    
    
    
    
    
    /// 영수증 데이터를 추가하는 함수
    /// 새로운 인덱스 패스를 반환
    func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple]) {
        // 추가할 섹션의 IndexPath 저장
        var sectionsToInsert = IndexSet()
        // 추가할 행의 IndexPath 저장
        var rowsToInsert = [IndexPath]()
        
        for (receiptID, receipt) in toAdd {
            // 이미 존재하는 영수증은 건너뜀
            if self.receiptSections.contains(where: { $0.receipts.contains { $0.getReceiptID == receiptID } }) {
                continue
            }
            
            // 영수증의 날짜를 가져옴
            let date = receipt.date
            // 현재 섹션들 중에서 해당 날짜(date)를 가진 섹션의 인덱스를 찾음
            var sectionIndex = self.receiptSections.firstIndex { $0.date == date }
            
            // 해당 섹션이 없는 경우
            if sectionIndex == nil {
                // 섹션이 없는 경우 새 섹션을 추가
                let newSection = ReceiptSection(date: date, receipts: [])
                self.receiptSections.append(newSection)
                sectionIndex = self.receiptSections.count - 1
                // 새 섹션의 인덱스를 sectionsToInsert에 추가
                sectionsToInsert.insert(sectionIndex!)
            }
            
            // 해당 섹션이 존재하는 경우, 행 추가
            let rowIndex = self.receiptSections[sectionIndex!].receipts.count
            rowsToInsert.append(IndexPath(row: rowIndex, section: sectionIndex!))
            
            // 새 영수증의 ViewModel을 생성하고 섹션에 추가
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: receipt)
            self.receiptSections[sectionIndex!].receipts.append(viewModel)
        }

        // 섹션 내 영수증들을 시간 순서대로 정렬
        for sectionIndex in 0..<self.receiptSections.count {
            self.receiptSections[sectionIndex].receipts.sort { $0.getReceipt.time > $1.getReceipt.time }
        }

        // 데이터 변경 이벤트를 저장하는 배열
        var dataChanges: [String: [IndexPath]] = [:]
        
        // 새 섹션이 추가된 경우, sectionInsert 이벤트 추가
        if !sectionsToInsert.isEmpty {
            let indexPathsToInsert = sectionsToInsert.map { IndexPath(row: 0, section: $0) }
            dataChanges[DataChangeType.sectionInsert.notificationName] = indexPathsToInsert
        }
        
        // 행이 추가된 경우, sectionReload 이벤트 추가
        if !rowsToInsert.isEmpty {
            dataChanges[DataChangeType.sectionReload.notificationName] = rowsToInsert
        }

        // 데이터 변경 이벤트를 indexPaths에 저장
        self._changedIndexPaths.merge(dataChanges) { (_, new) in new }

        // 클로저를 한 번만 호출하여 데이터 변경 이벤트 전달
        if !dataChanges.isEmpty {
            self.fetchSuccessClosure?()
        }
    }
}
