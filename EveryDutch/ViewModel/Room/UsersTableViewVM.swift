//
//  SettlementDetailsTableVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

class UsersTableViewVM: UsersTableViewVMProtocol {
    // MARK: - 프로퍼티
    private var userDataManager: IndexPathDataManager<User> = IndexPathDataManager()
    
    
    
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
    
    
    
    
    // MARK: - 룸 데이터 메니저
    private var roomDataManager: RoomDataManagerProtocol
    private var customTableEnum: UsersTableEnum
    
    // 클로저
    var userCardDataClosure: (() -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         _ customTableEnum: UsersTableEnum) {
        self.roomDataManager = roomDataManager
        self.customTableEnum = customTableEnum
    }
    
    func selectUser(index: Int) {
        self.roomDataManager.selectUser(index: index) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.userCardDataClosure?()
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
}
    
    

// MARK: - 테이블뷰
extension UsersTableViewVM {
    /// 유저 수
    var numbersOfUsers: Int {
        return self.roomDataManager.getNumOfRoomUsers
    }
    
    /// 셀의 뷰모델 반환
    func cellViewModel(at index: Int) -> UsersTableViewCellVMProtocol? {
        return self.roomDataManager.getIndexToUsersVM(index: index)
    }
    
    /// 테이블뷰 스크롤 여부
    var tableViewIsScrollEnabled: Bool {
        switch self.customTableEnum {
        case .isSettleMoney:
            return self.numbersOfUsers >= 5
        case .isRoomSetting:
            return false
        case .isSettle:
            return true
        }
    }
    func validateRowCountChange(
        currentRowCount: Int,
        changedUsersCount: Int
    ) -> Bool {
        return currentRowCount + changedUsersCount == self.numbersOfUsers
    }
    
    func validateRowExistenceForUpdate(
        indexPaths: [IndexPath],
        totalRows: Int
    ) -> Bool {
        return !indexPaths.contains { $0.row >= totalRows }
    }
}

// MARK: - 인덱스패스
extension UsersTableViewVM {
    // 유저 데이터 인덱스패스
    func userDataChanged(_ userInfo: [String: Any]) {
        self.userDataManager.dataChanged(userInfo)
    }

    func getPendingUserDataIndexPaths() -> [String: [IndexPath]] {
        return self.userDataManager.getPendingIndexPaths()
    }

    func resetPendingUserDataIndexPaths() {
        self.userDataManager.resetIndexPaths()
    }
}
