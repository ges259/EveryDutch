//
//  MainVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class MainVM: MainVMProtocol {
    private var cellViewModels: [CollectionViewCellVM] = []
    
    
    
                        
    
    
    // MARK: - Fix
    // 1. 데이터를 받아서 cellViewModel에 넣는다.
    var items: [(String, String)] = []
    init() {
        self.items = [("캐나다 여행", "Detail 1"),
                      ("스터디", "Detail 2"),
                      ("데이트 통장", "Detail 3"),
                      ("대학 동기", "Detail 4"),
                      ("가족 통장", "Detail 5"),
                      ("고등학교 애들", "Detail 6"),
                      ("Item 7", "Detail 7")]
        // 예시 데이터 로드
        cellViewModels = items.map {
            CollectionViewCellVM(title: $0.0,
                                 time_String: $0.1,
                                 imgUrl: $0.0)
        }
    }
    
    
    
    
    
    // cellViewModels 반환
     func cellViewModel(at index: Int) -> CollectionViewCellVM {
         return self.cellViewModels[index]
     }

     var numberOfItems: Int {
         return self.cellViewModels.count
     }
}
