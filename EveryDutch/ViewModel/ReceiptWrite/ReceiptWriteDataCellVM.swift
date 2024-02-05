//
//  ReceiptWriteDataCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/6/24.
//

import UIKit

protocol ReceiptWriteDataCellVMProtocol {
    // MARK: - [저장] price(가격)
    func savePriceText(text: String?)
    
    // MARK: - [형식] '원' 형식 삭제
    func removeWonFormat(priceText: String?) -> String?
    
    // MARK: - [형식] 형식 유지하며 수정
    func formatPriceForEditing(_ newText: String?) -> String?
    
    // MARK: - [형식] ',' 및 '원'형식 설정
    var priceInfoTFText: String? { get }
}


final class ReceiptWriteDataCellVM: ReceiptWriteDataCellVMProtocol {
    
    private var receiptEnum: ReceiptEnum
    
    
    private var price: Int? = 0
    
    
    init(withReceiptEnum receiptEnum: ReceiptEnum) {
        self.receiptEnum = receiptEnum
        
        
        
    }
    
    
    // MARK: - [저장] price(가격)
    func savePriceText(text: String?) {
        // 형식 제거
        if let priceInt = NumberFormatter.removeFormat(
            price: text) {
            // price 값 설정
            self.price = Int(priceInt)
        } else {
            self.price = nil
        }
    }
    
    
    
    // MARK: - [형식] '원' 형식 삭제
    func removeWonFormat(priceText: String?) -> String? {
        // '원' 형식을 삭제 후 리턴
        return NumberFormatter.removeWon(price: priceText)
    }
    
    // MARK: - [형식] 형식 유지하며 수정
    func formatPriceForEditing(_ newText: String?) -> String? {
        return NumberFormatter.formatStringChange(
            price: newText)
    }
    
    // MARK: - [형식] ',' 및 '원'형식 설정
    var priceInfoTFText: String? {
        return self.price == nil
        ? nil
        // formatNumberString() -> 10,000원 처럼 바꾸기
        : NumberFormatter.formatString(price: self.price)
    }
}
