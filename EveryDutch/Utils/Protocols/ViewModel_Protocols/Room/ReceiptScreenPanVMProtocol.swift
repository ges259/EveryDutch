//
//  ReceiptScreenPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol ReceiptScreenPanVMProtocol {
    
    
    var getReceipt: Receipt { get }
    
//    var currentNumOfUsers: Int { get }
    var getPayMethod: String { get }
//    func getDataCellTitle(index: Int) -> String?
    
    func cellViewModel(at index: Int) -> ReceiptScreenPanUsersCellVM
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int { get }
    func getCellHeight(section: Int) -> CGFloat
    func getCellData(index: Int) -> ReceiptDataCell
    
    
    func getHeaderTitle(section: Int) -> String
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int
}
