//
//  ChatSettingProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol CardScreenVMProtocol {
    var first_Mode: CardMode { get }
    var second_Mode: CardMode? { get }
    
    var bottomBtn_IsHidden: Bool { get }
    var bottomBtn_Title: String? { get }
    var secondStv_IsHidden: Bool { get }
}
