//
//  MainCoordinaator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainCoordProtocol: Coordinator {
    func profileEditScreen()
    func roomEditScreen()
    
    func settlementMoneyRoomScreen()
    func profileScreen()
    func selectALgoinMethodScreen()
}
