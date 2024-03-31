//
//  AppCoordProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2/9/24.
//

import Foundation

protocol AppCoordProtocol: Coordinator {
    func mainScreen()
    func selectALoginMethodScreen()
    func mainToMakeUser()
}
