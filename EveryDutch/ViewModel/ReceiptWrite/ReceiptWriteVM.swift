//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWriteVMProtocol {
    
    // MARK: - 모델
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    
    
    
    // MARK: - 클로저
    var errorClosure: ((ErrorEnum) -> Void)?
    var successMakeReceiptClosure: (() -> Void)?
    /// 디바운싱이 끝나면 VC에서 endEditing()를 호출하는 클로저
    var debouncingClosure: (() -> Void)?
    
    var calculatePriceClosure: ((String?) -> Void)?
    /// 더치 버튼 클로저
    var dutchBtnClosure: (() -> Void)?
    
    
    
    // MARK: - 데이터
    private var receiptWriteEnum: [ReceiptWriteEnum] = ReceiptWriteEnum.allCases
    private var cellDataDictionary: [Int: [ReceiptWriteCellVMProtocol]] = [:]
    private var receiptDataDict: [String: Any?] = [:]
    /// 선택된 '유저ID' 및 '금액'
    private var usersMoneyDict: [String : Int] = [:]
    // PeopleSelectionPanScreen에 데이터를 전달해야 하는 데이터
    var payer: RoomUserDataDict = [:]
    var selectedUsers: RoomUserDataDict = [:]
    
    
    
    // MARK: - 데이터
    /// 키보드 높이
    var keyboardHeight: CGFloat = 291.31898
    /// 디바운스 타이머
    private var debounceTimer: DispatchWorkItem?
    /// 누적 금액
    private var cumulativeMoney: Int = 0 {
        didSet { self.calculatePriceClosure?(self.moneyCountLblText) }
    }
    /// 더치 가격
    var dutchedPrice: Int = 0
    /// 1 / N 버튼 여부
    var isDutchedMode: Bool = false
    /// 테이블뷰가 수정 중인지 여부
    /// 테이블뷰 수정 중, endEditing(true)가 불리지 않게 하기 위한 메서드
    var isUserDataTableEditing: Bool = false
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         receiptAPI: ReceiptAPIProtocol) {
        self.roomDataManager = roomDataManager
        self.receiptAPI = receiptAPI
        
        // 데이터 셀 모델 만들기
        self.createDataCellVM()
    }
}










// MARK: - [테이블뷰]
extension ReceiptWriteVM {
    /// 섹션의 타입
    func setSectionIndex(section: Int) -> ReceiptWriteEnum? {
        return self.receiptWriteEnum[section]
    }
    /// 섹션의 인덱스
    private func sectionIndex(receiptWriteEnum: ReceiptWriteEnum) -> Int {
        return receiptWriteEnum.rawValue
    }
    /// 섹션의 개수
    var getSectionCount: Int {
        return self.receiptWriteEnum.count
    }
    /// 데이터 셀 개수
    func getNumOfCell(section: Int) -> Int {
        return self.cellDataDictionary[section]?.count ?? 0
    }
    /// 헤더 타이틀
    func getHeaderTitle(section: Int) -> String {
        return self.receiptWriteEnum[section].headerTitle
    }
    /// 셀의 인덱스가 마지막 셀인지 확인하는 메서드
    func isLastCell(row: Int) -> Bool {
        let sectionIndex = self.sectionIndex(receiptWriteEnum: .receiptData)
        let lastIndex = (self.cellDataDictionary[sectionIndex]?.count ?? 0) - 1
        return lastIndex == row
    }
    
    
    
    // MARK: - 셀 업데이트 시
    /// 셀 업데이트 시 사용하는 인덱스패스를 리턴
    func findReceiptEnumIndex(_ receiptEnum: ReceiptCellEnum) -> IndexPath {
        return IndexPath(row: receiptEnum.rawValue, section: 0)
    }
    /// NoDataView의 isHidden 여부
    var getNoDataViewIsHidden: Bool {
        return !(self.selectedUsers.count == 0)
    }
    
    // MARK: - 셀의 데이터 반환
    private func getReceiptData<T>(type: ReceiptCellEnum) -> T? {
        guard let data = self.receiptDataDict[type.databaseString] else {
            return nil
        }
        return data as? T
    }
    /// receiptDataDict에 담긴 가격을 Int타입으로 반환
    private func getCurrentPrice() -> Int? {
        return self.getReceiptData(type: .price)
    }
    /// receiptDataDict에 담긴 payerID를 String타입으로 반환
    private func getCurrentPayerID() -> String? {
        return self.getReceiptData(type: .payer)
    }
    /// payer딕셔너리에 담긴 payer의 이름을 반환
    var getSelectedUsers: String? {
        return self.payer.values.first?.userName ?? nil
    }
    /// moneyCountLbl(남은 금액 레이블)에 적힐 텍스트 설정
    var moneyCountLblText: String? {
        let price = self.calculateRemainingMoney
        return NumberFormatter.formatString(price: price)
    }
    /// 남은 금액 계산 <-> 금액(price) - 누적 금액(cumulativeMoney) 을 계산
    private var calculateRemainingMoney: Int {
        let price = self.getCurrentPrice() ?? 0
        let total = price - self.cumulativeMoney
        return total
    }
    
    
    
    // MARK: - 데이터 저장
    private func saveReceiptData(type: ReceiptCellEnum, data: Any?) {
        // 데이터베이스 String 가져오기
        self.receiptDataDict[type.databaseString] = data
    }
    /// 날짜 저장
    func saveCalenderDate(date: Date) {
        let dateInt = Int(date.timeIntervalSince1970)
        self.saveReceiptData(type: .date, data: dateInt)
    }
    /// 시간 저장
    func saveTime(time: String) {
        self.saveReceiptData(type: .time, data: time)
    }
    // 메모 저장
    func saveMemo(context: String) {
        if context != "" { self.saveReceiptData(type: .memo, data: context) }
    }
    /// price(가격) 저장
    func savePriceText(price: Int) {
        if price != 0 { self.saveReceiptData(type: .price, data: price) }
    }
    /// payer 선택된 유저의 이름
    func isPayerSelected(selectedUser: RoomUserDataDict) {
        self.payer = selectedUser
        self.saveReceiptData(type: .payer, data: selectedUser.first?.key)
    }
    
    
    
    // MARK: - [푸터뷰]
    /// 푸터뷰의  높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        
        let type = self.setSectionIndex(section: section)
        switch type {
        case .receiptData:  return 0
        case .userData:     return self.userSectionHeight()
        default:            return 0
        }
    }
    /// 유저 섹션 - 푸터뷰 높이
    private func userSectionHeight() -> CGFloat {
        return self.selectedUsers.count == 0
        ? 45 + 225
        : 45
    }
    /// 유저 섹션 - 더치 버튼 색상
    var dutchBtnBackgroundColor: UIColor {
        return self.selectedUsers.count == 0
        ? UIColor.normal_white
        : UIColor.deep_Blue
    }
}










// MARK: - 셀의 뷰모델

extension ReceiptWriteVM {
    
    // MARK: - 셀의 뷰모델 생성
    /// [유저 셀] 생성
    func createUsersCellVM(addedUsers: RoomUserDataDict) {
        // userData섹션의 인덱스를 가져옴
        let sectionIndex = self.sectionIndex(receiptWriteEnum: .userData)
        //
        var usersCellArray: [ReceiptWriteUsersCellVM] = []
        // 추가된 유저 처리
        addedUsers.forEach { (userID, roomUser) in
            if self.selectedUsers[userID] == nil {
                // 셀의 뷰모델 생성
                let newCellVM = ReceiptWriteUsersCellVM(userID: userID,
                                                        roomUsers: roomUser)
                usersCellArray.append(newCellVM)
                // 선택되었다고 표시
                self.selectedUsers[userID] = roomUser
            }
        }
        // 유저셀 뷰모델 배열이 있다면,
        if (self.cellDataDictionary[sectionIndex] != nil) {
            // 배열 합치기
            self.cellDataDictionary[sectionIndex]?.append(contentsOf: usersCellArray)
            // 유저셀 뷰모델 배열이 없다면,
        } else {
            // 배열 생성
            self.cellDataDictionary[sectionIndex] = usersCellArray
        }
    }
    
    /// [데이터 셀] 생성
    private func createDataCellVM() {
        guard let dataCell = self.receiptWriteEnum.first?.createProviders(
            isReceiptWriteVC: true,
            withData: nil) else { return }
        self.cellDataDictionary = dataCell
        // 날짜 저장
        self.saveCalenderDate(date: Date())
    }
    
    // MARK: - 셀 뷰모델 반환
    private func getCurrentReceiptWriteCellVM<T: ReceiptWriteCellVMProtocol>(
        as type: T.Type,
        indexPath: IndexPath) -> T?
    {
        if let dd = self.cellDataDictionary[indexPath.section]?[indexPath.row] as? T {
            return dd
        }
        return nil
    }
    func getDataCellViewModel(indexPath: IndexPath) -> ReceiptWriteDataCellVMProtocol? {
        return self.getCurrentReceiptWriteCellVM(
            as: ReceiptWriteDataCellVM.self,
            indexPath: indexPath)
    }
    func getUserCellViewModel(indexPath: IndexPath) -> ReceiptWriteUsersCellVMProtocol? {
        return self.getCurrentReceiptWriteCellVM(
            as: ReceiptWriteUsersCellVM.self,
            indexPath: indexPath)
    }
}











// MARK: - 계산할 사람 선택

extension ReceiptWriteVM {
    
    // MARK: - 추가될 셀의 IndexPath
    func indexPathsForAddedUsers(_ users: RoomUserDataDict) -> [IndexPath]
    {
        // userData섹션의 인덱스를 가져옴
        let sectionIndex = self.sectionIndex(receiptWriteEnum: .userData)
        
        guard let cellCount = self.cellDataDictionary[sectionIndex]?.count else { return [] }
        let startIndex = cellCount - users.count
        return (startIndex..<(startIndex + users.count)).map { IndexPath(row: $0, section: 1) }
    }
    
    // MARK: - 유저 뷰모델 삭제
    func deleteData(removedUsers: RoomUserDataDict) {
        // userData섹션의 인덱스를 가져옴
        let sectionIndex = self.sectionIndex(receiptWriteEnum: .userData)
        
        // MARK: - Fix
        // 에러처리 추가
        guard let usersVM = self.cellDataDictionary[sectionIndex] as? [ReceiptWriteUsersCellVMProtocol]
        else {
            self.errorClosure?(.NoPersonalID)
            return
        }
        
        removedUsers.keys.forEach { userID in
            // 가격 없애기
            self.removePrice(userID: userID)
            // 선택된 상태에서 없애기
            self.selectedUsers.removeValue(forKey: userID)
            
            if let index = usersVM.firstIndex(where: { $0.userID == userID }) {
                self.cellDataDictionary[sectionIndex]?.remove(at: index)
            }
        }
    }
    
    // MARK: - 삭제 될 셀의 IndexPath
    func indexPathsForRemovedUsers(_ users: RoomUserDataDict) -> [IndexPath] {
        // userData섹션의 인덱스를 가져옴
        let sectionIndex = self.sectionIndex(receiptWriteEnum: .userData)
        // 삭제할 IndexPath를 담는 배열
        var indexPaths = [IndexPath]()
        
        
        // MARK: - Fix
        // 에러처리 추가
        // cellDataDictionary에서 유저셀의 뷰모델이 맞는지 확인
        guard let usersVM = self.cellDataDictionary[sectionIndex] as? [ReceiptWriteUsersCellVMProtocol]
        else {
            self.errorClosure?(.NoPersonalID)
            return []
        }
        // 유저셀의 뷰모델에서 userID를 가져옴
        users.keys.forEach { userID in
            // 가져온 userID와 삭제할 userID가 맞다면,
            if let index = usersVM.firstIndex(where: { $0.userID == userID }) {
                // indexPath배열에 추가
                indexPaths.append(IndexPath(row: index, section: 1))
            }
        }
        return indexPaths
    }
}










// MARK: - 가격 설정

extension ReceiptWriteVM {
    
    // MARK: - 분기 처리
    func calculatePrice(userID: String, price: Int?) {
        // [ 제거 ] - 아무것도 적지 않았다면 (nil값)
        if price == nil {
            // 만약 유저가 돈이 있다면 -> 0원으로 만들기
            self.removePrice(userID: userID)
            
        // [ 수정 ] - userID가 있다면
        } else if self.usersMoneyDict.keys.contains(userID) {
            self.modifyPrice(userID: userID, price: price)
            
        // [ 추가 ] - userID가 없다면
        } else {
            self.createPrice(userID: userID, price: price)
        }
    }
    
    // MARK: - [제거]
    // (가격 제거 시) + (테이블에서 유저 삭제 시)
    private func removePrice(userID: String) {
        // 만약 유저가 돈이 있다면
        // -> 0원으로 만들기
        if self.usersMoneyDict.keys.contains(userID) {
            // 유저의 '원래 돈' 가져오기
            let money = self.usersMoneyDict[userID] ?? 0
            // 누적 금액 차감
            self.cumulativeMoney -= money
            // usersMoneyDict에서 userID없애기
            self.usersMoneyDict.removeValue(forKey: userID)
        }
    }
    
    // MARK: - [수정]
    private func modifyPrice(userID: String, price: Int?) {
        // 원래 돈 및 수정 돈가져오기
        guard let original = self.usersMoneyDict[userID],
              let new = price
        else { return }
        
        self.usersMoneyDict[userID] = price
        
        let cumulativeMoney = self.cumulativeMoney
        
        // 금액 재설정
        // 수정 금액 - 원래 설정된 있던 금액
        self.cumulativeMoney = (cumulativeMoney - original + new)
    }
    
    // MARK: - [추가]
    private func createPrice(userID: String, price: Int?) {
        guard let price = price else { return }
        // 딕셔너리에 추가
        self.usersMoneyDict[userID] = price
        // 금액 추가
        self.cumulativeMoney += price
    }
    
    // MARK: - 가격 재분배 (1/N 버튼)
    func dutchBtnTapped() {
        // 현재 금액 옵셔널 바인딩,
        // + 현재 금액이 0원이 아니라면
        guard let price = self.getCurrentPrice(),
                price != 0,
                self.selectedUsers.count != 0 else {
            // 현재 금액이 0원이라면 -> 0원으로 모두 맞춤
            self.cumulativeMoney = 0
            self.dutchBtnClosure?()
            return
        }
        
        // 각 사용자에게 할당될 더치 페이 금액 계산
        let dutchedPriceInt = price / self.selectedUsers.count
        // 금액을 저장
        self.dutchedPrice = dutchedPriceInt
        // 선택된 유저들에게 dutchedPrice 넣기
        self.selectedUsers.forEach { (userID: String, value: _) in
            return self.usersMoneyDict[userID] = dutchedPriceInt
        }
        // 누적 금액에 현재 금액(price)값 넣기 -> 클로저 호출(0원으로 만들기)
        self.cumulativeMoney = price
        // 현재 더치 버튼이 눌렸다고 표시
        self.isDutchedMode = true
        // 재분배 (더치 페이를 적용하여 테이블 뷰 업데이트)
        self.dutchBtnClosure?()
    }
}










// MARK: - 디바운싱
extension ReceiptWriteVM {
    /// 디바운싱을 멈추는 코드
    func stopDebouncing() {
        // 이전에 설정된 타이머가 있으면 취소합니다.
        self.debounceTimer?.cancel()
        
        self.isUserDataTableEditing = true
    }
    /// 다바운싱 코드
    func setDebouncing() {
        // 키보드가 닫히면 디바운싱 진행 (4초 뒤)
//        guard self.isTableViewEditing else { return }
        
        // 새로운 타이머 작업을 생성
        let task = DispatchWorkItem { [weak self] in
            self?.isUserDataTableEditing = false
            self?.debouncingClosure?()
        }
        
        // 4초 후에 작업을 실행하도록 예약
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: task)

        // 생성된 타이머 작업을 저장
        self.debounceTimer = task
    }
}










// MARK: - 유효성 검사
extension ReceiptWriteVM {
    func validationData() {
        var errors: [String] = []
        // 차례대로 유효성 검사 시작
        // 날짜, 메모, 시간, 가격, 계산 검사
        self.validateReceiptDetails(&errors)
        // 선택된 유저들의 정보를 [userID : [ "pay" : 0] 형태로 변환
        self.validatePaymentDetails(&errors)
        // 현재 남은 금액이 0원인지 확인
        self.validateCumulativeMoney(&errors)
        // 선택된 유저 중 0원으로 설정되어있는 유저가 있는 지 확인
        self.validateUserPayments(&errors)
        // 현재 paymentDetails값이 모두 같다면, [payment_method : 1] 저장. 하나라도 다르다면, [payment_method : 0] 저장.
        self.calculatePaymentMethod(&errors)
        
        // error 배열에 무언가 있다면(=에러가 있음)
        if !errors.isEmpty {
            // 모든 에러들을 처리
            self.errorClosure?(.validationError(errors))
        } else {
            // api작업 시작
            self.startReceiptAPI()
        }
    }
    
    /// 날짜, 메모, 시간, 가격, 계산 검사
    private func validateReceiptDetails(_ errors: inout [String]) {
        if let details = self.receiptWriteEnum.first?.validation(data: self.receiptDataDict) {
            errors.append(contentsOf: details)
            return
        }
    }
    
    /// 선택된 유저들의 정보를 [userID : [ "pay" : 0] 형태로 변환
    private func validatePaymentDetails(_ errors: inout [String]) {
        // 선택된 유저가 있는지 확인
            // 있다면, payment_detail 딕셔너리 구조로 만듦
        let details = self.toDictionary()
        
        if let details = details, !details.isEmpty {
            self.receiptDataDict[DatabaseConstants.payment_details] = details
        } else {
            errors.append(DatabaseConstants.payment_details)
        }
    }
    
    /// 선택된 유저가 있다면, [userID : [ "pay" : 0] 형태로 리턴하는 메서드
    private func toDictionary() -> [String: [String: Any]]?  {
        // 선택된 유저가 없다면 -> 리턴 nil
        guard !self.selectedUsers.isEmpty else { return nil }
        
        // 선택된 유저가 있다면 -> 정보 리턴
        return self.usersMoneyDict.reduce(into: [:]) { (result, pair) in
            let (key, value) = pair
            result[key] = ["pay": value]
        }
    }
    
    /// 현재 남은 금액이 0원인지 확인
    private func validateCumulativeMoney(_ errors: inout [String]) {
        if self.calculateRemainingMoney != 0 {
            errors.append(DatabaseConstants.culmulative_money)
        }
    }
    
    /// 선택된 유저 중 0원으로 설정되어있는 유저가 있는 지 확인
    private func validateUserPayments(_ errors: inout [String]) {
        let hasZeroPriceUser = self.selectedUsers.contains { self.usersMoneyDict[$0.key] == 0 }
        if hasZeroPriceUser {
            errors.append(DatabaseConstants.pay)
        }
    }
    
    /// 현재 paymentDetails값이
    /// 모두 같다면, [payment_method : 1] 저장.
    /// 하나라도 다르다면, [payment_method : 0] 저장.
    private func calculatePaymentMethod(_ errors: inout [String]) {
        // paymentDetails 내의 모든 값이 동일한지 여부에 따라 결제 방식 결정
        guard let firstValue = self.usersMoneyDict.values.first else {
            errors.append(DatabaseConstants.culmulative_money)
            print("\(#function) ----- Error -----")
            return
        }
        
        let isUniform = self.usersMoneyDict.values.allSatisfy { $0 == firstValue }
        self.receiptDataDict[DatabaseConstants.payment_method] = isUniform ? 1 : 0
    }
}










// MARK: - API

extension ReceiptWriteVM {
    
    // MARK: - 비동기 작업 시작
    // 비동기 작업을 시작하는 함수
    private func startReceiptAPI() {
        
        // 버전, payerID 가져오기
        guard let versionID = self.roomDataManager.getCurrentVersion,
              let payerID = self.getCurrentPayerID()
        else {
            self.errorClosure?(.readError)
            return
        }
        
        Task {
            do {
                // 딕셔너리의 값에 nil값이 있을 수 있으니 제외
                let dict = self.receiptDataDict.compactMapValues { $0 }
                // 영수증 만들기 + 영수증ID 가져오기
                let receiptKey = try await self.receiptAPI.createReceipt(
                    versionID: versionID,
                    dictionary: self.receiptDataDict)
                // User_Receipts에 영수증 ID 저장
                try await self.receiptAPI.saveReceiptForUsers(
                    receiptID: receiptKey,
                    users: Array(self.usersMoneyDict.keys))
                // 누적 금액 업데이트
                try await self.receiptAPI.updateCumulativeMoney(
                    versionID: versionID,
                    moneyDict: self.usersMoneyDict)
                // 페이백 업데이트
                try await self.receiptAPI.updatePayback(
                    versionID: versionID,
                    payerID: payerID,
                    moneyDict: self.usersMoneyDict)
                // API 작업 성공, 성공 결과를 completion으로 전달
                self.successMakeReceiptClosure?()
            } catch {
                // API 작업 실패, 실패 결과를 클로저를 통해 전달
                print("API 작업 실패: \(error)")
                self.errorClosure?(.readError)
            }
        }
    }
}
