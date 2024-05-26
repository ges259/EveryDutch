//
//  CheckReceiptPanVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/11/24.
//

import UIKit
enum ReceiptCheckEnum {
    case receiptWriteVC
    case editScreenVC
}

protocol CheckReceiptPanVMProtocol {
    var getNilValueArray: Int { get }
    func getLabelText(index: Int) -> String
}

final class CheckReceiptPanVM: CheckReceiptPanVMProtocol {
    private var validationDict = [String]()
    private let type: ReceiptCheckEnum
    
    var getNilValueArray: Int {
        return self.validationDict.count
    }
    init(type: ReceiptCheckEnum, validationDict: [String]) {
        self.type = type
        self.validationDict = validationDict
    }
    
    
    func getLabelText(index: Int) -> String {
        let text: String = self.validationDict[index]
        
        switch self.type {
        case .receiptWriteVC:
            return self.receiptWriteVCLabelText(text)
        case .editScreenVC:
            return self.editScreenVCLabelText(text)
        }
    }
    private func receiptWriteVCLabelText(_ dbString: String) -> String {
        switch dbString {
        case DatabaseConstants.context:
            return "✓  메모을 작성해 주세요"
        case DatabaseConstants.price:
            return "✓  가격을 설정해 주세요"
        case DatabaseConstants.payer: 
            return "✓  계산한 사람을 설정해 주세요."
        case DatabaseConstants.pay: 
            return "✓  0원으로 설정되어있는 사람이 있습니다."
        case DatabaseConstants.payment_details: 
            return "✓  함께 계산한 사람을 모두 선택해 주세요."
        case DatabaseConstants.culmulative_money: 
            return "✓  금액이 맞지 않습니다."
        default:
            return "✓  정확히 입력해 주세요."
        }
    }
    private func editScreenVCLabelText(_ dbString: String) -> String {
        switch dbString {
        case DatabaseConstants.user_name:
            return "✓  사용자의 이름을 설정해 주세요."
        case DatabaseConstants.personal_ID:
            return "✓  개인 ID를 설정해 주세요."
        case DatabaseConstants.room_name:
            return "✓  정산방의 이름을 설정해 주세요."
        case DatabaseConstants.class_name:
            return "✓  모임의 이름을 설정해 주세요."
        case DatabaseConstants.duplicatePersonalID:
            return "✓  개인ID가 중복되었습니다."
        default:
            return "✓  정확히 입력해 주세요."
        }
    }
}

