//
//  MainCoordinaator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainCoordProtocol: Coordinator {
    func multiPurposeScreen(_ cardScreen_Enum: CardScreen_Enum)
    func settlementRoomScreen()
    func profileScreen()
    func selectALgoinMethodScreen()
}
