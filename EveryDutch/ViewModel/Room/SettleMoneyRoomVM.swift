//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    private var cellViewModels: [SettlementTableViewCellVM] = []
    
    
    var items: [(String, String)] = []
    init() {
        self.items = [("노브랜드", "쁨 외 1명"),
                      ("맥도날드", "노주영 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("KFC", "노주영 외 1명"),
                      ("맘스터치", "쁨 외 1명"),
                      ("맥도날드", "쁨 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("맘스터치", "쁨 외 1명"),
                      ("맥도날드", "노주영 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("맥도날드", "쁨 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("KFC", "노주영 외 1명"),
                      ("맥도날드", "쁨 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("맘스터치", "쁨 외 1명"),
                      ("맥도날드", "쁨 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("맘스터치", "쁨 외 1명"),
                      ("맥도날드", "노주영 외 1명"),
                      ("KFC", "노주영 외 1명"),
                      ("노브랜드", "쁨 외 1명"),
                      ("맥도날드", "노주영 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("KFC", "노주영 외 1명"),
                      ("맘스터치", "쁨 외 1명"),
                      ("맥도날드", "쁨 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("맘스터치", "쁨 외 1명"),
                      ("맥도날드", "노주영 외 1명"),
                      ("노브랜드", "노주영 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("맥도날드", "쁨 외 1명"),
                      ("롯데리아", "맥형 외 1명"),
                      ("KFC", "노주영 외 1명"),
                      ("맥도날드", "쁨 외 1명")]
        // 예시 데이터 로드
        cellViewModels = items.map {
            SettlementTableViewCellVM(content: $0.0,
                                      payer: $0.1)
        }
    }
    // cellViewModels 반환
     func cellViewModel(at index: Int) -> SettlementTableViewCellVM {
         return self.cellViewModels[index]
     }

     var numberOfItems: Int {
         return self.cellViewModels.count
     }
    
    deinit {
        print("------------------------------------------------------------")
    }
}
