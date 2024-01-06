//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class CardScreenVM: CardScreenVMProtocol {
    
    private var cardScreen_Enum: CardScreen_Enum = .profile
//    var mode: CardMode =
    
    
    init(cardScreen_Enum: CardScreen_Enum) {
        self.cardScreen_Enum = cardScreen_Enum
    }
    
    
    
    var first_Mode: CardMode {
        switch self.cardScreen_Enum {
        case .makeRoom: return .makeRoom
        case .editProfile: return .infoFix_User
        case .profile: return .readMode_profile
        }
    }
    
    var second_Mode: CardMode? {
        switch self.cardScreen_Enum {
        case .makeRoom: return .infoFix_User
        case .editProfile: return nil
        case .profile: return .info_Btn
        }
    }
    
    
    
    
//    var first_Title
//    var second_Title
    
    
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
