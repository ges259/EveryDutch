//
//  NumberFormatter+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/20/24.
//

import Foundation

extension NumberFormatter {
    static func formatString(price: Int?) -> String? {
        guard let price = price else { return nil }
        
        let numberFormatter = NumberFormatter()
        // 숫자를 10,000 형식으로 표시
        numberFormatter.numberStyle = .decimal
        
        // 직접 NSNumber 객체를 생성하여 포매팅 적용
        // 뒤에 '원' 붙이기
        return numberFormatter.string(from: NSNumber(value: price))?.appending("원")
    }
    
    
    static func removeFormat(price: String?) -> String? {
        return price?
            .replacingOccurrences(of: "원", with: "")
            .replacingOccurrences(of: ",", with: "")
    }
}
