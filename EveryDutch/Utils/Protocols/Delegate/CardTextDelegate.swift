//
//  CardTextDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import Foundation

protocol ReceiptWriteDataCellDelegate: AnyObject {
    
    func cellIsTapped(_ cell: ReceiptWriteDataCell, type: ReceiptCellEnum?)
    
    
    func finishPriceTF(price: Int)
    func finishMemoTF(memo: String)
}
