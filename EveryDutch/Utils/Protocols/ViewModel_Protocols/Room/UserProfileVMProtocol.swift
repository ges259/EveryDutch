//
//  UserProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import Foundation

protocol UserProfileVMProtocol {
    var isRoomManager: Bool { get }
    
    var btnStvInsets: CGFloat { get }
    var getUserDecoTuple: UserDecoTuple { get }
}
