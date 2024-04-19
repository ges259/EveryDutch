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
    private var validationDict = [ReceiptCheck]()
    
    var getNilValueArray: Int {
        return self.validationDict.count
    }
    init(validationDict: [ReceiptCheck]) {
        self.validationDict = validationDict
    }
    
    func getLabelText(index: Int) -> String {
        return validationDict[index].cellTitle
    }
}

