//
//  MainCoordinaator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainCoordProtocol: Coordinator {
    func cardScreen(_ cardScreen_Enum: CardScreen_Enum)
    func settlementMoneyRoomScreen(room: Rooms)
    func profileScreen()
    func selectALgoinMethodScreen()
}
