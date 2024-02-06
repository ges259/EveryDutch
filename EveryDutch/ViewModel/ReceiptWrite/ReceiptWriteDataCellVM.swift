//
//  ReceiptWriteDataCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/6/24.
//

import UIKit

protocol ReceiptWriteDataCellVMProtocol {
    
    var getReceiptEnum: ReceiptEnum { get }
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
    
}









final class ReceiptWriteDataCellVM: ReceiptWriteDataCellVMProtocol {
    
    private var receiptEnum: ReceiptEnum
    private var price: Int? = 0
    
    let TF_MAX_COUNT: Int = 12
    
    
    func updateMemoCount(count: Int) -> String {
        return "\(count) / \(self.TF_MAX_COUNT)"
    }
    
    
    
    var isTfBeginEditing: Bool {
        return self.receiptEnum == .price
        ? true
        : false
    }
    
    
    var isMemoType: Bool {
        return self.receiptEnum == .memo
        ? true
        : false
    }
    
    
    
    
    // MARK: - [형식] ',' 및 '원'형식 설정
    func priceInfoTFText(price: Int) -> String? {
        // 가격 레이블에 바뀐 가격을 ',' 및 '원'을 붙여 표시
        return NumberFormatter.formatString(
            price: price)
    }
    
    
    var getReceiptEnum: ReceiptEnum {
        return self.receiptEnum
    }
    
    
    
    
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
    
    func removeAllFormat(priceText: String?) -> Int {
        guard let priceString = NumberFormatter.removeFormat(price: priceText),
              let priceInt = Int(priceString)
        else { return 0 }
        
        return priceInt
    }
    
    
    
    // MARK: - [형식] 형식 유지하며 수정
    func formatPriceForEditing(_ newText: String?) -> String? {
        return NumberFormatter.formatStringChange(
            price: newText)
    }
}
