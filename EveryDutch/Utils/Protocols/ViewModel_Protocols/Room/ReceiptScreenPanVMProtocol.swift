//
//  ReceiptScreenPanVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit

protocol ReceiptScreenPanVMProtocol {
    
    
    var getReceipt: Receipt { get }
    var getPayerName: String { get }
//    var currentNumOfUsers: Int { get }
    var getPayMethod: String { get }
    
    
    func cellViewModel(at index: Int) -> ReceiptScreenPanCellVM
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int { get }
    func getCellHeight(section: Int) -> CGFloat
    func getReceiptEnum(index: Int) -> ReceiptEnum
    
    // MARK: - 헤더의 타이틀
    func getCellText(section: Int) -> String
    
    func getCellImg(section: Int) -> UIImage?
    func getHeaderTitle(section: Int) -> String
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int
}
