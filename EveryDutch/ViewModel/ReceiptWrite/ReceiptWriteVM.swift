//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWriteVMProtocol {
    
    // MARK: - 모델
    private var cellViewModels: [ReceiptWriteCellVM] = [] {
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
    
    
    
    
    var cumulativeMoney: Int = 0
    
    var usersMoneyDict: [String : Int] = [:]
    
    

    

    
    

    
    
    
    // MARK: - 최대 글자 수
    /// 최대 글자 수 :  12
    let TF_MAX_COUNT: Int = 12
    
    
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
    

    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
    }
}










// MARK: - 가격 설정

extension ReceiptWriteVM {
    
    // MARK: - 가격 설정
    func calculatePrice(userID: String?, price: Int?) -> String? {
        // userID 옵셔널 바인딩
        guard let userID = userID else {
            return self.moneyCountLblText
        }
        
        // [ 제거 ]
        // 아무것도 적지 않았다면 (nil값)
        if price == nil {
            // 만약 유저가 돈이 있다면
            // -> 0원으로 만들기
            self.removePrice(userID: userID, price: price)
            
        // [ 수정 ]
        // userID가 있다면
        } else if self.usersMoneyDict.keys.contains(userID) {

            self.modifyPrice(userID: userID, price: price)
            
        // [ 추가 ]
        } else {
            self.createPrice(userID: userID, price: price)
        }
        return self.moneyCountLblText
    }
    
    private func removePrice(userID: String, price: Int?) {
        // 만약 유저가 돈이 있다면
        // -> 0원으로 만들기
        if self.usersMoneyDict.keys.contains(userID),
           let price = price {
            // usersMoneyDict에서 userID없애기
            self.usersMoneyDict.removeValue(forKey: userID)
            
            // 금액 차감
            self.cumulativeMoney -= price
        }
    }
    private func modifyPrice(userID: String, price: Int?) {
        // 원래 돈 및 수정 돈가져오기
        guard let original = self.usersMoneyDict[userID],
              let new = price
        else { return }
        // 금액 재설정
        // 수정 금액 - 원래 설정된 있던 금액
        self.cumulativeMoney += new - original
    }
    private func createPrice(userID: String, price: Int?) {
        // 딕셔너리에 추가
        self.usersMoneyDict[userID] = price
        // 금액 추가
        self.cumulativeMoney += price!
    }
}
    









// MARK: - 메모

extension ReceiptWriteVM {
    
    // MARK: - 메모 글자 수 저장
    func updateMemoCount(count: Int) -> String {
        return "\(count) / \(self.TF_MAX_COUNT)"
    }
}










// MARK: - 텍스트필드

extension ReceiptWriteVM {
    
    // MARK: - '원' 삭제
    func removeWonFormat(priceText: String?) -> String? {
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
    
    // MARK: - '0' 만 있을 경우
    func updatePriceText(_ text: String) -> String {
        return text == "0" ? "10" : text
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
        if let price = self.price {
            let total = price - self.cumulativeMoney
            return NumberFormatter.formatString(price: total)
        }
        return "0원"
    }
}










// MARK: - 타임 피커

extension ReceiptWriteVM {
    
    // MARK: - 타임 피커 시간 설정
    func timePickerString(hour: Int, minute: Int) -> String {
        // 선택한 시간과 분을 이용하여 필요한 작업 수행
        let hour = String(format: "%02d", hour)
        let minute = String(format: "%02d", minute)
        // 선택한 시간을 timeInfoLbl에 넣기
        return "\(hour) : \(minute)"
    }
    
    // MARK: - 타임피커의 형식 설정
    func timePickerFormat(_ row: Int) -> String {
        return String(format: "%02d", row)
    }
}
    
    
    
    
    
    
    



// MARK: - 단일 선택 - 셀 설정
    
extension ReceiptWriteVM {
    
    // MARK: - 선택된 유저의 이름
    func isPayerSelected(user: RoomUserDataDictionary) -> String? {
        self.payer = user
        return user.values.first?.roomUserName
    }
}










// MARK: - 다중 선택 - 셀 설정

extension ReceiptWriteVM {
    
    // MARK: - 셀의 뷰모델 만들기
    func makeCellVM(selectedUsers: RoomUserDataDictionary) {
        // 방의 유저들 정보 가져오기
        self.selectedUsers = selectedUsers
        
        self.cellViewModels.removeAll()
        // 유저 정보 보내기
        self.cellViewModels = self.selectedUsers.map { (userID, roomUser) in
            ReceiptWriteCellVM(
                userID: userID,
                roomUsers: roomUser)
        }
    }
    
    func deleteCellVM(userID: String?) {
        // userID 옵셔널 바인딩
        guard let userID = userID else { return }
        // 선택 해제
        self.selectedUsers.removeValue(forKey: userID)
        // 셀의 뷰모델 중, 삭제할 userID를 가지고 있는 셀을 가져오기
        if let index = self.cellViewModels
            .firstIndex(where: { $0.userID == userID }) {
            // 셀의 뷰모델 삭제
            self.cellViewModels.remove(at: index)
        }
    }
    
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM {
        return self.cellViewModels[index]
    }
}
