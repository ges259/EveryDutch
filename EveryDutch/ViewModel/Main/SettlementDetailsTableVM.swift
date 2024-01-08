//
//  SettlementDetailsTableVM.swift
//  EveryDutch
//
//  Created by 계은성 on 1/7/24.
//

import Foundation

class SettlementDetailsVM {
    // 셀 데이터를 저장하는 배열
    var cellViewModels: [SettlementDetailsCellVM] = []
    
    
    var customTableEnum: CustomTableEnum
    
    
    
    
    
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
                      ("노주영", "30,005"),]
        
        
        // 예시 데이터 로드
        cellViewModels = items.map {
            SettlementDetailsCellVM(profileImageURL: "",
                                    userName: $0.0,
                                    price: $0.1, 
                                    customTableEnum: self.customTableEnum)
        }
    }
    
    // cellViewModels 반환
     func cellViewModel(at index: Int) -> SettlementDetailsCellVM {
         return self.cellViewModels[index]
     }
    
    // 사용자 입력 처리
    func updatePrice(forCellAt index: Int,
                     withPrice price: String) {
        guard index < cellViewModels.count else { return }
        cellViewModels[index].price = price
    }
    
    
    
    // 셀 삭제 메서드
    func deleteCell(at index: Int) {
        guard index < cellViewModels.count else { return }
        cellViewModels.remove(at: index)
    }
}
