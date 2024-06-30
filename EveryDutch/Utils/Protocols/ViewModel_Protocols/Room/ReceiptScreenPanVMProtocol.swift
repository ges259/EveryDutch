//
//  ReceiptScreenPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol ReceiptScreenPanVMProtocol {
    
    
    func cellViewModel(at index: Int) -> ReceiptScreenPanUsersCellVMProtocol
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int { get }
    func getCellHeight(section: Int) -> CGFloat
    func getCellData(index: Int) -> ReceiptCellTypeTuple
    
    
    func getHeaderTitle(section: Int) -> String
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int
}
