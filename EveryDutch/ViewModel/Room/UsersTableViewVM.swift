//
//  SettlementDetailsTableVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

class UsersTableViewVM: UsersTableViewVMProtocol {
    // MARK: - 프로퍼티
    
    
    

    
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
    var customTableEnum: UsersTableEnum
    
    
    
    // MARK: - 셀의 뷰모델
    // 셀 데이터를 저장하는 배열
//    var cellViewModels: [UsersTableViewCellVM] = []
    
    // MARK: - 열거형
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol,
         _ customTableEnum: UsersTableEnum) {
        self.roomDataManager = roomDataManager
        self.customTableEnum = customTableEnum
        
        
        // MARK: - Fix
//        if !(customTableEnum == .isSettleMoney) {
//            self.makeCellVM()
//        }
    }
}
    
    

// MARK: - 테이블뷰

extension UsersTableViewVM {
    
    // MARK: - 유저 수
    var numbersOfUsers: Int {
        return self.roomDataManager.getNumOfRoomUsers
    }
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> UsersTableViewCellVMProtocol {
        print(#function)
        return self.roomDataManager.getUsersViewModel(index: index)
    }
    
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
