//
//  CheckReceiptPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/11/24.
//

import UIKit

protocol CheckReceiptPanVMProtocol {
    var getNilValueArray: Int { get }
    func getLabelText(index: Int) -> String
    
    
}

final class CheckReceiptPanVM: CheckReceiptPanVMProtocol {
    
    private var validationDict = [String: Any?]()
    // `nil` 값을 가진 키들을 저장할 배열을 선언
    private var nilValueArray = [String]()
    
    
    var getNilValueArray: Int {
        return self.nilValueArray.count
    }
    
    
    
    init(validationDict: [String: Any?]) {
        self.validationDict = validationDict
        
        self.findNilValueKeys()
        
    }
    
    func getLabelText(index: Int) -> String {
        let keyString: String = self.nilValueArray[index]
        
        switch keyString {
        case DatabaseConstants.context:
            return "✓  메모을 작성해 주세요"
        case DatabaseConstants.price:
            return "✓  가격을 설정해 주세요"
        case DatabaseConstants.payer:
            return "✓  계산한 사람을 설정해 주세요."
        case DatabaseConstants.payment_details:
            return "✓  함께 계산한 사람을 모두 선택해 주세요."
        case DatabaseConstants.culmulative_money:
            return "✓  금액이 맞지 않습니다. 정확히 입력해 주세요."
        case DatabaseConstants.pay:
            return "✓  0원으로 설정되어있는 사람이 있습니다."
        default: return ""
        }
    }
    
    
    
    
    private func findNilValueKeys(){
        // 딕셔너리를 순회하며 `nil` 값을 확인합니다.
        for (key, value) in self.validationDict {
            
            if value as? String == "" {
                // 값이 `nil`인 경우, 키를 배열에 추가합니다.
                self.nilValueArray.append(key)
            }
        }
    }
}

