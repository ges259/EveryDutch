//
//  PlusBtnCoordinating.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

protocol ProfileEditVCCoordProtocol: Coordinator {
    
    func colorPickerScreen()
    func imagePickerScreen()
    
    
//    func makeRoom(room: Rooms)
    func makeProviderData(with: ProviderModel)
}
