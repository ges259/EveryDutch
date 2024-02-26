//
//  ReceiptWriteDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 2/25/24.
//

import Foundation

protocol ReceiptWriteDelegate: AnyObject {
    func successReceipt(receipt: Receipt)
}
