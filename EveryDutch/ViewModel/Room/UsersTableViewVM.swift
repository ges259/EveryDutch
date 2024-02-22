//
//  SettlementDetailsTableVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

class UsersTableViewVM: UsersTableViewVMProtocol {
    // MARK: - 프로퍼티
    
    
    
    // MARK: - 유저 수
    var numbersOfUsers: Int {
        return self.cellViewModels.count
    }
    
    // MARK: - 첫번째 사람인지 판단
    var isFirstBtnTapped: Bool = true
    
    
    private let btnColorArray: [UIColor] = [
        .normal_white,
        .unselected_gray]
    
    var getBtnColor: [UIColor] {
        let btnColor = self.isFirstBtnTapped
        ? self.btnColorArray
        : self.btnColorArray.reversed()
        return btnColor
    }
    
    
    
    
    // MARK: - 모델
    
    
    
    // MARK: - 룸 데이터 메니저
    private var roomDataManager: RoomDataManagerProtocol
    
    // MARK: - 셀의 뷰모델
    // 셀 데이터를 저장하는 배열
    var cellViewModels: [UsersTableViewCellVM] = []
    
    // MARK: - 열거형
    var customTableEnum: UsersTableEnum
    // MARK: - 유저 딕셔너리
    var users: RoomUserDataDict = [:]
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         _ customTableEnum: UsersTableEnum) {
        self.roomDataManager = roomDataManager
        self.customTableEnum = customTableEnum
        
        if !(customTableEnum == .isSettleMoney) {
            self.makeCellVM()
        }
    }
}
    
    
 







extension UsersTableViewVM {
    
    // MARK: - 테이블뷰 스크롤 여부
    var tableViewIsScrollEnabled: Bool {
        switch self.customTableEnum {
        case .isSettleMoney, .isRoomSetting:
            return false
        case .isSettle:
            return true
        }
    }
}










// MARK: - 셀의 뷰모델 설정

extension UsersTableViewVM {
    
    // MARK: - 셀 생성
    // moneyData: [CumulativeAmount]
    // 셀 가져와서 표시
    func makeCellVM() {
        // 유저를 가져옮
        let users = self.roomDataManager.getRoomUsersDict
        
        // 셀 만들기 시작
        self.cellViewModels = users.map({ (userID, roomUser) in
            // -> 유저 아이디를 통해
            // - 누적 금액을 가져옮
            let cumulativeAmount = self.roomDataManager.getIDToCumulativeAmount(
                userID: userID)
            // - payback을 가져옮
            let paybackPrice = self.roomDataManager.getIDToPayback(
                userID: userID)
            // 셀 만들기
            return UsersTableViewCellVM(
                userID: userID,
                moneyData: cumulativeAmount,
                paybackPrice: paybackPrice,
                roomUsers: roomUser,
                customTableEnum: self.customTableEnum)
        })
    }
    
    // MARK: - 셀 업데이트
    // 사용자 입력 처리
    private func updatePrice(forCellAt index: Int,
                             withPrice price: Int) {
        guard index < self.cellViewModels.count else { return }
        self.cellViewModels[index].cumulativeAmount = price
    }
    
    // MARK: - 셀 삭제
    // 셀 삭제 메서드
    private func deleteCell(at index: Int) {
        guard index < self.cellViewModels.count else { return }
        self.cellViewModels.remove(at: index)
    }
    
    // MARK: - 셀 뷰모델 설정
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> UsersTableViewCellVM {
        return self.cellViewModels[index]
    }
}
