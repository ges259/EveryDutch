//
//  SettlementDetailsTableVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

protocol UsersTableViewVMProtocol {
    
}




class UsersTableViewVM: UsersTableViewVMProtocol {
    // 셀 데이터를 저장하는 배열
    var cellViewModels: [UsersTableViewCellVM] = []
    

    var customTableEnum: CustomTableEnum
    
    var users: [RoomUsers]  = []
    
    var numbersOfUsers: Int {
        return self.cellViewModels.count
    }
    // 계산하는 사람인지 판단
    var isPayer: Bool = false
    
    
    
    // MARK: - Fix
    init(_ customTableEnum: CustomTableEnum) {
        self.customTableEnum = customTableEnum
    }
    
    
    
    
    
    // 셀 가져와서 표시
    func makeCellVM(users: [RoomUsers]) {
        self.cellViewModels = users.map { user in
            UsersTableViewCellVM(
                roomUsers: user,
                customTableEnum: self.customTableEnum)
        }
    }
    
    // MARK: - 셀 업데이트
    // 사용자 입력 처리
    func updatePrice(forCellAt index: Int,
                     withPrice price: String) {
        guard index < cellViewModels.count else { return }
        cellViewModels[index].price = price
    }
    
    // MARK: - 셀 삭제
    // 셀 삭제 메서드
    func deleteCell(at index: Int) {
        guard index < cellViewModels.count else { return }
        cellViewModels.remove(at: index)
    }
    
    // MARK: - 셀 뷰모델 설정
    // cellViewModels 반환
     func cellViewModel(at index: Int) -> UsersTableViewCellVM {
         return self.cellViewModels[index]
     }
}


/*
 
 // MARK: - 레이블 텍스트
 var topLblText: String? {
     switch self.customTableEnum {
     case .isReceiptScreen:
         return "정산 내역"
     case .isPeopleSelection:
         return self.isPayer
         ? "돈을 지불한 사람을 선택해 주세요."
         : "계산한 사람을 모두 선택해 주세요."
     case .isSettle:
         return "누적 금액"
     case .isSearch:
         return "검색"
     case .isSettleMoney, .isReceiptWrite, .isRoomSetting:
         return nil
     }
 }
 
 
 // MARK: - 상단 버튼 텍스트
 var btnTextArray: [String]? {
     switch self.customTableEnum {
     case .isSettleMoney, .isRoomSetting:
         return ["누적 금액", "받아야 할 돈"]
     case .isReceiptWrite:
         return ["1 / n", "직접 입력"]
     case .isReceiptScreen, .isPeopleSelection, .isSearch, .isSettle:
         return nil
     }
 }
 
 // MARK: - 상단 버튼 색상
 var topLblBackgroundColor: UIColor {
     return self.customTableEnum == .isSettle
     ? UIColor.medium_Blue
     : UIColor.normal_white
 }
 */