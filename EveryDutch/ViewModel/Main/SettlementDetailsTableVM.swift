//
//  SettlementDetailsTableVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import UIKit

class SettlementDetailsVM {
    // 셀 데이터를 저장하는 배열
    var cellViewModels: [SettlementDetailsCellVM] = []
    
    
    var customTableEnum: CustomTableEnum
    
    private let btnColorArray: [UIColor] = [UIColor.normal_white,
                                            UIColor.unselected_gray]
    
    
    var isFirstBtnTapped: Bool = false {
        didSet {
            let imgArray = self.isFirstBtnTapped
            ? self.btnColorArray
            : self.btnColorArray.reversed()
            // 클로저 실행
            self.segmentBtnClosure?(imgArray)
        }
    }
    
    
    // 계산하는 사람인지 판단
    var isPayer: Bool = false
    
    
    // MARK: - 클로저
    var segmentBtnClosure: (([UIColor]) -> Void)?
    
    
    
    // MARK: - Fix
    // 1. 데이터를 받아서 cellViewModel에 넣는다.
    var items: [(String, String)] = []
    init(_ customTableEnum: CustomTableEnum) {
        self.customTableEnum = customTableEnum
        
        self.items = [("김게성", "30,000"),
                      ("소주안먹는근육몬", "30,001"),
                      ("걔", "30,002"),
                      ("맥형", "30,003"),
                      ("지후", "30,004"),
                      ("노주영", "30,005"),
                      ("김게성", "30,000"),
                                    ("소주안먹는근육몬", "30,001"),
                                    ("걔", "30,002"),
                                    ("맥형", "30,003"),
                                    ("지후", "30,004"),
                                    ("노주영", "30,005"),
                      ("김게성", "30,000"),
                                    ("소주안먹는근육몬", "30,001"),
                                    ("걔", "30,002"),
                                    ("맥형", "30,003"),
                                    ("지후", "30,004"),
                                    ("노주영", "30,005"),
                      ("김게성", "30,000"),
                                    ("소주안먹는근육몬", "30,001"),
                                    ("걔", "30,002"),
                                    ("맥형", "30,003"),
                                    ("지후", "30,004"),
                                    ("노주영", "30,005"),
                      ("김게성", "30,000"),
                                    ("소주안먹는근육몬", "30,001"),
                                    ("걔", "30,002"),
                                    ("맥형", "30,003"),
                                    ("지후", "30,004"),
                                    ("노주영", "30,005"),
                      ("김게성", "30,000"),
                                    ("소주안먹는근육몬", "30,001"),
                                    ("걔", "30,002"),
                                    ("맥형", "30,003"),
                                    ("지후", "30,004"),
                                    ("노주영", "30,005"),
        ]
        
        
        // 예시 데이터 로드
        cellViewModels = items.map {
            SettlementDetailsCellVM(profileImageURL: "",
                                    userName: $0.0,
                                    price: $0.1,
                                    customTableEnum: self.customTableEnum)
        }
    }
    
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
    
    
//    var dutchBtnColor: UIColor {
//        return self.isFirstBtnTapped
//        ? UIColor.medium_Blue
//        : UIColor.normal_white
//    }
    
    
    
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
     func cellViewModel(at index: Int) -> SettlementDetailsCellVM {
         return self.cellViewModels[index]
     }
}
