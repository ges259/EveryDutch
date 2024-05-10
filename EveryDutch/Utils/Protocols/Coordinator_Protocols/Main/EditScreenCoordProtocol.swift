//
//  PlusBtnCoordinating.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

protocol EditScreenCoordProtocol: Coordinator {
    
    func imagePickerScreen()
    
    
    //    func makeRoom(room: Rooms)
    func makeProviderData(with: EditProviderModel)
    
    func checkReceiptPanScreen(_ validationDict: [String])
}
