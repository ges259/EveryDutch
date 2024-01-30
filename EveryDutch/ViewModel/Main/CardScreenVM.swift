//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class CardScreenVM: CardScreenVMProtocol {
    
    private var cardScreen_Enum: CardScreen_Enum = .profile
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(cardScreen_Enum: CardScreen_Enum) {
        self.cardScreen_Enum = cardScreen_Enum
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    var first_Mode: CardMode {
        switch self.cardScreen_Enum {
        case .makeRoom: return .roomMake
        case .editProfile: return .profile_Fix
        case .profile: return .profile
        }
    }
    
    var second_Mode: CardMode? {
        switch self.cardScreen_Enum {
        case .profile: return .setting_Auth
        case .makeRoom, .editProfile: return nil
        }
    }
    
    
    
    
    
    var bottomBtn_IsHidden: Bool {
        switch self.cardScreen_Enum {
        case .makeRoom, .editProfile: return false
        case .profile: return true
        }
    }
    
    var secondStv_IsHidden: Bool {
        switch self.cardScreen_Enum {
        case .editProfile: return false
        case .makeRoom, .profile: return true
        }
    }
    
    
    
    var bottomBtn_Title: String? {
        switch self.cardScreen_Enum {
        case .makeRoom: return "정산방 생성"
        case .editProfile: return "완료"
        case .profile: return nil
        }
    }
    
    
    
    
    
    
    
}
