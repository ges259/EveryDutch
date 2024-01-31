//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class ProfileEditVM: ProfileEditVMProtocol {
    
    private var profileEditEnum: ProfileEditEnum = .profile
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(profileEditEnum: ProfileEditEnum) {
        self.profileEditEnum = profileEditEnum
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    var getCurrentMode: ProfileEditEnum {
        return self.profileEditEnum
    }
    
    
    var bottomBtn_IsHidden: Bool {
        switch self.profileEditEnum {
        case .profileEdit: return false
        case .profile: return true
        }
    }
    
    var secondStv_IsHidden: Bool {
        switch self.profileEditEnum {
        case .profileEdit: return false
        case .profile: return true
        }
    }
    
    
    
    var bottomBtn_Title: String? {
        switch self.profileEditEnum {
        case .profileEdit: return "완료"
        case .profile: return nil
        }
    }
    
    
    
    
    
    
    
}
