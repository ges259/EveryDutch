//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWriteVMProtocol {
    
    // MARK: - 뷰 모델
    private var usersCellViewModels: [ReceiptWriteUsersCellVM] = [] {
        didSet {
            print("*************************")
            print(self.usersCellViewModels.count)
            print("__________________________")
        }
    }
    // MARK: - 뷰 모델
    private var dataCellViewModels: [ReceiptWriteDataCellVM] = [] {
        didSet {
            print("*************************")
            print(self.dataCellViewModels.count)
            print("__________________________")
        }
    }
    
    
    
    
    
    

    
    
    
    // MARK: - 모델
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    
    var date: Int = Int(NSDate().timeIntervalSince1970)
    var time: String = Date.returnCurrenTime()
    
    var memo: String?
    var price: Int?
    var payer: RoomUserDataDict?
    //  [String : User]
    var selectedUsers: RoomUserDataDict = [:]
    
    
    // ********************************************
    
    var receiptDict = [String : Any?]()
//    private var validationDict = [ReceiptCheck]()
    
    
    
    
    
    
    
    
    
    
    
// MARK: - 디바운스
    
    
    
    // MARK: - 디바운싱 클로저
    /// 디바운싱이 끝나면 VC에서 endEditing()를 호출하는 클로저
    var debouncingClosure: (() -> Void)?
    
    // MARK: - 테이블뷰가 수정 중인지 여부
    /// 테이블뷰 수정 중, endEditing(true)가 불리지 않게 하기 위한 메서드
    var isUserDataTableEditing: Bool = false
    
    // MARK: - 디바운스 타이머
    /// 디바운스 타이머
    private var debounceTimer: DispatchWorkItem?
    
    
    
    
    
// MARK: - 테이블뷰
    
    
    
// MARK: - [공통]
    
    private var receiptWriteEnum: [ReceiptWriteEnum] = ReceiptWriteEnum.allCases
    
    // MARK: - 헤더 타이틀
    func getHeaderTitle(section: Int) -> String {
        return self.receiptWriteEnum[section].headerTitle
    }
    
    // MARK: - 섹션의 개수
    var getSectionCount: Int {
        return self.receiptWriteEnum.count
    }
    
    // MARK: - 첫 번째 셀 모서리
    func isFistCell(_ receiptEnum: ReceiptEnum) -> Bool {
        return receiptEnum == self.receiptEnum.first
        ? true
        : false
    }
    
    // MARK: - 마지막 셀 모서리
    func isLastCell(_ receiptEnum: ReceiptEnum) -> Bool {
        return receiptEnum == self.receiptEnum.last
        ? true
        : false
    }
    
    
    
    
// MARK: - [데이터 섹션]
    // payment_Method를 제외한 모든 타입들을 가져옴
    private var receiptEnum: [ReceiptEnum] = ReceiptEnum.allCases.filter { $0 != .payment_Method }
    
    // MARK: - 데이터 셀 개수
    var getNumOfReceiptEnum: Int {
        return self.receiptEnum.count
    }
    
    // MARK: - 데이터 셀 Enum
    func getReceiptEnum(index: Int) -> ReceiptEnum {
        return self.receiptEnum[index]
    }
    
    
    
    
    
// MARK: - [셀 인덱스]
    
    
    
    // MARK: - 인덱스 리턴 함수
    func findReceiptEnumIndex(_ receiptEnum: ReceiptEnum) -> IndexPath {
        if let index = self.receiptEnum.firstIndex(of: receiptEnum) {
            return IndexPath(row: index, section: 0)
        }
        return IndexPath(row: 0, section: 0)
    }
    
    
    
// MARK: - [유저 섹션]
    
    
    
    // MARK: - 유저 섹션 개수
    var numOfUsers: Int {
        return self.selectedUsers.count
    }
    
    // MARK: - 테이블뷰 isHidden
    var tableIsHidden: Bool {
        return self.numOfUsers == 0
        ? true
        : false
    }
    
    // MARK: - 데이터 없을 때 뷰
    var getNoDataViewIsHidden: Bool {
        return !(self.selectedUsers.count == 0)
    }
    
    
    
    
    
// MARK: - [푸터뷰]

    
    
    // MARK: - 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        return section == 0
        ? 0
        : self.userSectionHeight()
    }
    
    // MARK: - 유저 섹션
    private func userSectionHeight() -> CGFloat {
        return self.selectedUsers.count == 0
        ? 45 + 225
        : 45
    }
    
    
    
    
    
// MARK: - 누적 금액
    
    
    
    // MARK: - 누적금액 클로저
    var calculatePriceClosure: ((String?) -> Void)?
    
    
    // MARK: - 누적 금액
    private var cumulativeMoney: Int = 0 {
        didSet {
            self.calculatePriceClosure?(self.moneyCountLblText)
        }
    }

    // MARK: - 선택된 유저 및 금액
    private var usersMoneyDict: [String : Int] = [:]
    
    
    
    
    
// MARK: - 더치 버튼
    
    
    
    // MARK: - 더치 버튼 클로저
    var dutchBtnClosure: (() -> Void)?
    
    // MARK: - 1 / N 버튼 여부
    var isDutchedMode: Bool = false
    
    // MARK: - 더치 가격
    var dutchedPrice: Int = 0
    
    var dutchBtnBackgroundColor: UIColor {
        return self.selectedUsers.count == 0
        ? UIColor.normal_white
        : UIColor.deep_Blue
    }
    
    
    
// MARK: - 키보드 높이
    var keyboardHeight: CGFloat = 291.31898
    
    
    
    
    
    
// MARK: - 날짜 저장
    func saveCalenderDate(date: Date) {
        let dateInt = Int(date.timeIntervalSince1970)
        self.date = dateInt
    }
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         receiptAPI: ReceiptAPIProtocol) {
        self.roomDataManager = roomDataManager
        self.receiptAPI = receiptAPI
        
        
        // 데이터 셀 모델 만들기
        self.createDataCellVM()
    }
}










// MARK: - 디바운싱 코드

extension ReceiptWriteVM {
    
    func stopDebouncing() {
        // 이전에 설정된 타이머가 있으면 취소합니다.
        self.debounceTimer?.cancel()
        
        self.isUserDataTableEditing = true

    }
    
    /// 다바운싱 코드
    func setDebouncing() {
        // 키보드가 닫히면 디바운싱 진행 (4초 뒤)
//        guard self.isTableViewEditing else { return }
        
        // 새로운 타이머 작업을 생성합니다.
        let task = DispatchWorkItem { [weak self] in
            self?.isUserDataTableEditing = false
            self?.debouncingClosure?()
        }
        
        // 4초 후에 작업을 실행하도록 예약합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: task)

        // 생성된 타이머 작업을 저장합니다.
        self.debounceTimer = task
    }
}










// MARK: - 가격 설정

extension ReceiptWriteVM {
    
    // MARK: - 가격 설정
    func calculatePrice(userID: String, price: Int?) {
        // [ 제거 ] - 아무것도 적지 않았다면 (nil값)
        if price == nil {
            // 만약 유저가 돈이 있다면
            // -> 0원으로 만들기
            self.removePrice(userID: userID)
            
            
        // [ 수정 ] - userID가 있다면
        } else if self.usersMoneyDict.keys.contains(userID) {
            self.modifyPrice(userID: userID, price: price)
            
            
        // [ 추가 ] - userID가 없다면
        } else {
            self.createPrice(userID: userID, price: price)
        }
    }
    
    // MARK: - 가격 제거
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
    
    // MARK: - 가격 수정
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
    
    // MARK: - 가격 추가
    private func createPrice(userID: String, price: Int?) {
        guard let price = price else { return }
        // 딕셔너리에 추가
        self.usersMoneyDict[userID] = price
        // 금액 추가
        self.cumulativeMoney += price
    }
}
    









// MARK: - 가격 재분배 (1/N 버튼)
extension ReceiptWriteVM {
    func dutchBtnTapped() {
        // 현재 금액 옵셔널 바인딩,
        // + 현재 금액이 0원이 아니라면
        guard let price = self.price, 
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










// MARK: - 가격 텍스트필드

extension ReceiptWriteVM {
    
    // MARK: - [저장] price(가격)
    func savePriceText(price: Int) {
        
        self.price = price == 0
        ? nil
        : price
    }
    
    // MARK: - [형식] 남은 금액 레이블 텍스트 설정
    var moneyCountLblText: String? {
        let price = self.calculateRemainingMoney
        return NumberFormatter.formatString(price: price)
    }
    
    // MARK: - 남은 금액 계산
    private var calculateRemainingMoney: Int {
        let price = self.price ?? 0
        let total = price - self.cumulativeMoney
        return total
    }
}













// MARK: - 타임 피커

extension ReceiptWriteVM {
    
    // MARK: - 시간 설정 + 시간 저장
    func timePickerString(hour: Int, minute: Int) -> String {
        // 선택한 시간과 분을 이용하여 필요한 작업 수행
        let hour = String(format: "%02d", hour)
        let minute = String(format: "%02d", minute)
        // 선택한 시간을 timeInfoLbl에 넣기
        return "\(hour) : \(minute)"
    }
    
    // MARK: - 형식 설정
    func timePickerFormat(_ row: Int) -> String {
        return String(format: "%02d", row)
    }
    
    // MARK: - 현재 시간 반환
    func getCurrentTime() -> [Int] {
        let now = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        return [hour, minute]
    }
}
    
    
    
    
    
    
    



// MARK: - [1명] payer 선택
    
extension ReceiptWriteVM {
    
    // MARK: - 선택된 유저의 이름
    func isPayerSelected(selectedUser: RoomUserDataDict) {
        self.payer = selectedUser
    }
    
    var getSelectedUsers: String? {
        return self.payer?.values.first?.userName
    }
}










// MARK: - [여러명] paymentDetails 선택

extension ReceiptWriteVM {
    
    // MARK: - 추가될 셀의 IndexPath
    func indexPathsForAddedUsers(_ users: RoomUserDataDict) -> [IndexPath] {
        let startIndex = self.usersCellViewModels.count - users.count
        return (startIndex..<(startIndex + users.count)).map { IndexPath(row: $0, section: 1) }
    }
    
    // MARK: - 유저 삭제
    func deleteData(removedUsers: RoomUserDataDict) {
        // 제거된 유저 처리
        removedUsers.keys.forEach { userID in
            self.deleteCellVM(userID: userID)
        }
    }
    
    // MARK: - 삭제 될 셀의 IndexPath
    func indexPathsForRemovedUsers(_ users: RoomUserDataDict) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        users.keys.forEach { userID in
            if let index = self.usersCellViewModels.firstIndex(where: { $0.userID == userID }) {
                indexPaths.append(IndexPath(row: index, section: 1))
            }
        }
        return indexPaths
    }
    
    // MARK: - 셀의 뷰모델 삭제
    // 셀 뷰모델 삭제
    func deleteCellVM(userID: String?) {
        guard let userID = userID else { return }
        // 가격 없애기
        self.removePrice(userID: userID)
        // 선택된 상태에서 없애기
        self.selectedUsers.removeValue(forKey: userID)
        // 뷰모델 없애기
        if let index = self.usersCellViewModels.firstIndex(where: { $0.userID == userID }) {
            self.usersCellViewModels.remove(at: index)
        }
    }
}










// MARK: - 셀의 뷰모델 생성

extension ReceiptWriteVM {
    
    // MARK: - 유저 셀
    func createUsersCellVM(addedUsers: RoomUserDataDict) {
        // 추가된 유저 처리
        addedUsers.forEach { (userID, roomUser) in
            if self.selectedUsers[userID] == nil {
                // 셀의 뷰모델 생성
                let newCellVM = ReceiptWriteUsersCellVM(userID: userID,
                                                   roomUsers: roomUser)
                self.usersCellViewModels.append(newCellVM)
                // 선택되었다고 표시
                self.selectedUsers[userID] = roomUser
            }
        }
    }
    
    // MARK: - 데이터 셀
    func createDataCellVM() {
        self.dataCellViewModels = self.receiptEnum.map { enumType in
            ReceiptWriteDataCellVM(withReceiptEnum: enumType)
        }
    }
}










// MARK: - 셀 뷰모델 반환

extension ReceiptWriteVM {
    
    // MARK: - 유저 셀
    /// cellViewModels 반환
    /// 테이블뷰 cellForRowAt에서 사용 됨
    func usersCellViewModel(at index: Int) -> ReceiptWriteUsersCellVM {
        return self.usersCellViewModels[index]
    }
    
    // MARK: - 데이터 셀
    func dataCellViewModel(at index: Int) -> ReceiptWriteDataCellVM {
        return self.dataCellViewModels[index]
    }
}










// MARK: - 하단 버튼

extension ReceiptWriteVM {
    
    // MARK: - 유효성 검사
    func prepareReceiptDataAndValidate(
        completion: @escaping Typealias.ReceiptCompletion)
    {
        // 영수증 데이터 딕셔너리 생성
        self.validationData { result in
            switch result {
            case .success(_):
                Task {
                    do {
                        try await self.startReceiptAPI()
                        
                        let dict = self.receiptDict.compactMapValues { $0 }
                        
                        let receipt = Receipt(dictionary: dict)
                        
                        // API 작업 성공, 성공 결과를 completion으로 전달
                        completion(.success(receipt))
                    } catch {
                        // API 작업 실패, 실패 결과를 completion으로 전달
                        print("API 작업 실패: \(error)")
                        completion(.failure(.receiptAPIFailed(self.receiptDict)))
                    }
                }
                break
                
                
            case .failure(let failedData):
                switch failedData {
                case .receiptCheckFailed(let validationResults):
                    completion(.failure(.receiptCheckFailed(validationResults)))
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - [조건 확인]
    
    
    
    // MARK: - 딕셔너리 만들기
    private func makeDictionary() {
        self.receiptDict[DatabaseConstants.type] = 0
        self.receiptDict[DatabaseConstants.payment_method] = self.calculatePaymentMethod()
        self.receiptDict[DatabaseConstants.date] = self.date
        self.receiptDict[DatabaseConstants.time] = self.time
    }
    
    // MARK: - 결제 세부 정보를 딕셔너리로 변환
    private func toDictionary() -> [String: [String: Any]]?  {
        // 선택된 유저가 없다면 -> 리턴 nil
        guard !self.selectedUsers.isEmpty else { return nil }
        
        // 선택된 유저가 있다면 -> 정보 리턴
        return self.usersMoneyDict.reduce(into: [:]) { (result, pair) in
            let (key, value) = pair
            result[key] = ["pay": value,
                           "done": false]
        }
    }
    
    // MARK: - 결제 방식 계산
    private func calculatePaymentMethod() -> Int {
        // paymentDetails 내의 모든 값이 동일한지 여부에 따라 결제 방식 결정
        guard let firstValue = self.usersMoneyDict.values.first else {
            return 1 // 딕셔너리가 비어있으면 기본값
        }
        
        let isUniform = self.usersMoneyDict.values.allSatisfy { $0 == firstValue }
        return isUniform ? 1 : 0
    }
    
    
    func validationData(
        completion: @escaping (Result<Void, ErrorEnum>) -> Void)
    {
        // 초기 영수증 데이터 딕셔너리 생성
        self.receiptDict.removeAll() // 기존 데이터가 있다면 초기화
        var validationResults: [ReceiptCheck] = []

        // 각 필드를 순회하며 유효성 검사 수행
        for check in ReceiptCheck.allCases {
            switch check {
            case .memo:
                if let memo = self.memo, !memo.isEmpty {
                    self.receiptDict[DatabaseConstants.context] = memo
                } else {
                    validationResults.append(.memo)
                }
            case .price:
                if let price = self.price, price != 0 {
                    self.receiptDict[DatabaseConstants.price] = price
                } else {
                    validationResults.append(.price)
                }
            case .payer:
                if let payer = self.payer, !payer.isEmpty {
                    self.receiptDict[DatabaseConstants.payer] = payer.keys.first
                } else {
                    validationResults.append(.payer)
                }
            case .payment_details:
                let details = self.toDictionary()
                if let details = details, !details.isEmpty {
                    self.receiptDict[DatabaseConstants.payment_details] = details
                } else {
                    validationResults.append(.payment_details)
                }
            case .culmulative_money:
                if self.calculateRemainingMoney == 0 {
                    // 이 케이스는 기존 로직에 따라 항상 통과하므로 별도의 저장 로직은 필요 없음
                } else {
                    validationResults.append(.culmulative_money)
                }
            case .pay:
                let hasZeroPriceUser = self.selectedUsers.contains { self.usersMoneyDict[$0.key] == 0 }
                if hasZeroPriceUser {
                    validationResults.append(.pay)
                }
            }
        }
        
        // 유효성 검사 결과에 따른 처리
        // 비어있다면 -> validation 성공
        if validationResults.isEmpty {
            print("유효성 검사 성공")
            self.makeDictionary()
            // 빈칸이 있는지 다시 확인
            completion(.success(()))
        }
        // 비어있지 않다면 -> validation 실패
        else {
            print("유효성 검사 실패")
            completion(.failure(.receiptCheckFailed(validationResults)))
        }
    }
}










// MARK: - API

extension ReceiptWriteVM {
    
    // MARK: - 비동기 작업 시작
    // 비동기 작업을 시작하는 함수
    func startReceiptAPI() async throws {
        let receiptKey = try await createReceipt()
        try await createReceiptForUsers(receiptID: receiptKey)
        try await updateCumulativeMoney()
        try await updatePayback()
    }
    
    // MARK: - 영수증 생성
    // 영수증 생성
    private func createReceipt() async throws -> String {
        guard let versionID = self.roomDataManager.getCurrentVersion else { throw ErrorEnum.readError }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.receiptAPI.createReceipt(
                versionID: versionID,
                dictionary: self.receiptDict,
                retryCount: 0) { result in
                    switch result {
                    case .success(let receiptKey):
                        continuation.resume(returning: receiptKey)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // MARK: - 유저별 영수증 생성
    private func createReceiptForUsers(receiptID: String) async throws {
        // 유저별 영수증 생성 로직 구현
        // 예시 코드는 생략되었습니다.
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            self.receiptAPI.saveReceiptForUsers(
                receiptID: receiptID,
                users: Array(self.usersMoneyDict.keys),
                retryCount: 0) { result in
                    switch result {
                    case .success():
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // MARK: - 누적 금액 업데이트
    private func updateCumulativeMoney() async throws {
        guard let versionID = self.roomDataManager.getCurrentVersion else { throw ErrorEnum.readError }
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            self.receiptAPI.updateCumulativeMoney(
                versionID: versionID,
                usersMoneyDict: self.usersMoneyDict,
                retryCount: 0) { result in
                    switch result {
                    case .success():
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // MARK: - 페이백 업데이트
    private func updatePayback() async throws {
        guard let versionID = self.roomDataManager.getCurrentVersion, let payerID = self.payer?.keys.first else { throw ErrorEnum.readError }
        
        var paybackDict = self.usersMoneyDict
        paybackDict.removeValue(forKey: payerID)
        
        return try await withCheckedThrowingContinuation { [weak self]continuation in
            guard let self = self else { return }
            
            self.receiptAPI.updatePayback(
                versionID: versionID,
                payerID: payerID,
                usersMoneyDict: paybackDict,
                retryCount: 0) { result in
                    switch result {
                    case .success():
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
