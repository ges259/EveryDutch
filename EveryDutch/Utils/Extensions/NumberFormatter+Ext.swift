//
//  NumberFormatter+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/20/24.
//

import Foundation

extension NumberFormatter {
    
    // MARK: - 형식 추가
    static func formatString(price: Int?) -> String? {
        guard let price = price else { return nil }
        
        let numberFormatter = NumberFormatter()
        // 숫자를 10,000 형식으로 표시
        numberFormatter.numberStyle = .decimal
        
        // 직접 NSNumber 객체를 생성하여 포매팅 적용
        // 뒤에 '원' 붙이기
        return numberFormatter.string(from: NSNumber(value: price))?.appending("원")
    }
    
    

    // MARK: - 형식 제거
    static func removeFormat(price: String?) -> String? {
        return price?
            .replacingOccurrences(of: "원", with: "")
            .replacingOccurrences(of: ",", with: "")
    }
    
    
    static func removeWon(price: String?) -> String? {
        return price?.replacingOccurrences(of: "원", with: "")
    }
    
    
    // MARK: - 형식 유지하며 수정
    // 가격 문자열을 형식화하는 함수
    static func formatStringChange(price: String?) -> String? {
        // '원'과 쉼표(,) 제거
        let price = self.removeFormat(price: price)
        
        // 문자열을 정수로 변환
        guard let price = Int(price ?? "") else { return nil }
        
        let numberFormatter = NumberFormatter()
        // 숫자를 10,000 형식으로 표시
        numberFormatter.numberStyle = .decimal
        
        // NSNumber 객체를 생성하여 포매팅 적용
        return numberFormatter.string(from: NSNumber(value: price))
    }
}
