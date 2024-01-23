//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWriteVMProtocol {
    
    // MARK: - 모델
    internal var cellViewModels: [ReceiptWriteCellVM] = [] {
        didSet {
            print("*************************")
            print(self.cellViewModels.count)
            print("__________________________")
        }
    }
    private var roomDataManager: RoomDataManagerProtocol
    
    var time: String?
    var memo: String?
    var price: Int?
    var payer: RoomUserDataDictionary?
    var selectedUsers: RoomUserDataDictionary = [:]
    
    
    
    
    
// MARK: - 클로저
    
    
    
    // MARK: - 누적금액 클로저
    var calculatePriceClosure: ((String?) -> Void)?

    
    // MARK: - 키보드 클로저
    /// 디바운싱이 끝나면 VC에서 endEditing()를 호출하는 클로저
    var debouncingClosure: (() -> Void)?
    
    
    
    
    
// MARK: - 디바운스
    
    
    
    // MARK: - 테이블뷰가 수정 중인지 여부
    /// 테이블뷰 수정 중, endEditing(true)가 불리지 않게 하기 위한 메서드
    var isTableViewEditing: Bool = false
    
    // MARK: - 디바운스 타이머
    /// 디바운스 타이머
    private var debounceTimer: DispatchWorkItem?
    
    
    
    
    
// MARK: - 테이블뷰
    
    
    
    // MARK: - 테이블뷰 개수
    var numOfUsers: Int {
        return self.selectedUsers.count
    }
    
    // MARK: - 테이블뷰 isHidden
    var tableIsHidden: Bool {
        return self.numOfUsers == 0
        ? true
        : false
    }
    
    
    
    
    
// MARK: - 유저 선택
    
    
    
    // MARK: - 누적 금액
    var cumulativeMoney: Int = 0 {
        didSet {
            self.calculatePriceClosure?(self.moneyCountLblText)
        }
    }
    
    // MARK: - 선택된 유저
    var usersMoneyDict: [String : Int] = [:]
    
    
    
    
    
// MARK: - 기타
    
    
    
    // MARK: - 최대 글자 수
    /// 최대 글자 수 :  12
    let TF_MAX_COUNT: Int = 12
    
    // MARK: - 키보드 높이
    var keyboardHeight: CGFloat = 291.31898
    
    // MARK: - 더치 버튼 클로저
    var dutchedClosure: (() -> Void)?
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
    }
}










// MARK: - 디바운싱 코드

extension ReceiptWriteVM {
    
    func stopDebouncing() {
        // 이전에 설정된 타이머가 있으면 취소합니다.
        self.debounceTimer?.cancel()
        
        self.isTableViewEditing = true

    }
    
    /// 다바운싱 코드
    func setDebouncing() {
        // 키보드가 닫히면 디바운싱 진행 (4초 뒤)
//        guard self.isTableViewEditing else { return }
        
        // 새로운 타이머 작업을 생성합니다.
        let task = DispatchWorkItem { [weak self] in
            self?.isTableViewEditing = false
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
        // 현재 금액 가져오기
        // 현재 금액이 0원이 아니라면
        if let price = self.price {
            let dutchedPrice = price / self.usersMoneyDict.count
            // 재분배
            self.cumulativeMoney = dutchedPrice
            
            
        } else {
            // 현재 금액이 0원이라면 -> 0원으로 모두 맞춤
            self.cumulativeMoney = 0
        }
        
        
        // 클로저가 호출 되는데.....?
        
        
        // 선택된 유저 모두 없애기
        
        
        
        // 선택된 유저 모두 가져오기
        
        // 누적 금액 -> 클로저 호출(0원으로 만들기)
    }
}










// MARK: - 가격 텍스트필드

extension ReceiptWriteVM {
    
    // MARK: - '원' 형식 삭제
    func removeWonFormat(priceText: String?) -> String? {
        // '원' 형식을 삭제 후 리턴
        return NumberFormatter.removeWon(price: priceText)
    }
    
    // MARK: - 형식 유지하며 수정
    func formatPriceForEditing(_ newText: String?) -> String? {
        return NumberFormatter.formatStringChange(
            price: newText)
    }
    
    // MARK: - price(가격) 저장
    func savePriceText(text: String?) {
        // 형식 제거
        if let priceInt = NumberFormatter.removeFormat(
            price: text) {
            // price 값 설정
            self.price = Int(priceInt)
        } else {
            self.price = nil
        }
    }

    // MARK: - 가격 레이블 텍스트 설정
    var priceInfoTFText: String? {
        return self.price == nil
        ? nil
        // formatNumberString() -> 10,000처럼 바꾸기
        : NumberFormatter.formatString(price: self.price)
    }
    
    // MARK: - 누적 금액 레이블 텍스트 설정
    var moneyCountLblText: String? {
        let price = self.price ?? 0
        let total = price - self.cumulativeMoney
        return NumberFormatter.formatString(price: total)
    }
}










// MARK: - 메모 글자 수 표시

extension ReceiptWriteVM {
    func updateMemoCount(count: Int) -> String {
        return "\(count) / \(self.TF_MAX_COUNT)"
    }
}










// MARK: - 타임 피커

extension ReceiptWriteVM {
    
    // MARK: - 시간 설정
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
}
    
    
    
    
    
    
    



// MARK: - [1명] payer 선택
    
extension ReceiptWriteVM {
    
    // MARK: - 선택된 유저의 이름
    func isPayerSelected(selectedUser: RoomUserDataDictionary) -> String? {
        self.payer = selectedUser
        return selectedUser.values.first?.roomUserName
    }
}













// MARK: - [여러명] paymentDetails 선택

extension ReceiptWriteVM {
    
    // MARK: - 유저 추가, 셀의 뷰모델 생성
    func addData(addedUsers: RoomUserDataDictionary) {
        // 추가된 유저 처리
        addedUsers.forEach { (userID, roomUser) in
            if self.selectedUsers[userID] == nil {
                // 셀의 뷰모델 생성
                let newCellVM = ReceiptWriteCellVM(userID: userID,
                                                   roomUsers: roomUser)
                self.cellViewModels.append(newCellVM)
                // 선택되었다고 표시
                self.selectedUsers[userID] = roomUser
            }
        }
    }
    
    // MARK: - 추가될 셀의 IndexPath
    func indexPathsForAddedUsers(_ users: RoomUserDataDictionary) -> [IndexPath] {
        let startIndex = self.cellViewModels.count - users.count
        return (startIndex..<(startIndex + users.count)).map { IndexPath(row: $0, section: 0) }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 유저 삭제
    func deleteData(removedUsers: RoomUserDataDictionary) {
        // 제거된 유저 처리
        removedUsers.keys.forEach { userID in
            self.deleteCellVM(userID: userID)
        }
    }
    
    // MARK: - 삭제 될 셀의 IndexPath
    func indexPathsForRemovedUsers(_ users: RoomUserDataDictionary) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        users.keys.forEach { userID in
            if let index = self.cellViewModels.firstIndex(where: { $0.userID == userID }) {
                indexPaths.append(IndexPath(row: index, section: 0))
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
        if let index = self.cellViewModels.firstIndex(where: { $0.userID == userID }) {
            self.cellViewModels.remove(at: index)
        }
    }
}










// MARK: - 셀 뷰모델 반환
extension ReceiptWriteVM {
    /// cellViewModels 반환
    /// 테이블뷰 cellForRowAt에서 사용 됨
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM {
        return self.cellViewModels[index]
    }
}
