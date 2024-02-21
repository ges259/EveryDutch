//
//  CardTextDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import Foundation

//protocol CardTextDelegate: AnyObject {
//    func firstStackViewTapped()
//    func secondStackViewTapped()
//    func editBtnTapped()
//}


protocol ReceiptWriteDataCellDelegate: AnyObject {
    func dateLblTapped()
    func timeLblTapped()
    func payerLblTapped()
    
    func priceTFTapped()
    func memoTFTapped()
    
    func finishPriceTF(price: Int)
    func finishMemoTF(memo: String)
}
