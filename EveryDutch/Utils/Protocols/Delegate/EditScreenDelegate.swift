//
//  MultiPurposeScreenDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import Foundation

protocol EditScreenDelegate: AnyObject {
//    func logout()
    func makeRoom(room: Rooms)
    func makeUser(user: User)
}
