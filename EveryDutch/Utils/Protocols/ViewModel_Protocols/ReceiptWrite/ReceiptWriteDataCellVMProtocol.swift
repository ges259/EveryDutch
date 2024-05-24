//
//  ReceiptWriteDataCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2/8/24.
//

import Foundation

protocol ReceiptWriteDataCellVMProtocol: ReceiptWriteCellVMProtocol {
    
    var getReceiptEnum: ReceiptCellEnum { get }
    var TF_MAX_COUNT: Int { get }
    func updateMemoCount(count: Int) -> String
    
    
    var isTfBeginEditing: Bool { get }
    var isMemoType: Bool { get }
    func removeAllFormat(priceText: String?) -> Int
    
    func priceInfoTFText(price: Int) -> String?
    
    // MARK: - [저장] price(가격)
    func savePriceText(text: String?)
    
    // MARK: - [형식] '원' 형식 삭제
    func removeWonFormat(priceText: String?) -> String?
    
    // MARK: - [형식] 형식 유지하며 수정
    func formatPriceForEditing(_ newText: String?) -> String?
    
    func getCurrentTime() -> String
}
