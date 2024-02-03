//
//  ProfileVCEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import Foundation
import UIKit

enum ProfileVCEnum: CaseIterable {
    case userInfo
    case others
    
    
    var headerTitle: String {
        switch self {
        case .userInfo: return "회원 정보"
        case .others: return "기타"
        }
    }
    
    var cellTitle: [String] {
        switch self {
        case .userInfo: 
            return ["계정 ID",
                    "닉네임"]
            
        case .others:
            return ["로그아웃",
                    "회원탈퇴"]
        }
    }
}
