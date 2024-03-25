//
//  ProfileVCEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import Foundation

enum ProfileVCEnum: Int, CaseIterable {
    case userInfo = 0
    case others
    
    var sectionIndex: Int {
        return self.rawValue
    }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [ProfileType] {
        switch self {
        case .userInfo:     return UserInfoType.allCases
        case .others:       return OthersType.allCases
        }
    }
}



enum UserInfoType: Int, ProfileType, Providers, CaseIterable {
    case personalID = 0
    case nickName
    
    func detail(from user: User?) -> String? {
        switch self {
        case .personalID: return user?.personalID
        case .nickName: return user?.userName
        }
    }
    
    var cellTitle: String {
        switch self {
        case .personalID: return "계정 ID"
        case .nickName: return "닉네임"
        }
    }
    var headerTitle: String {
        return "회원 정보"
    }
}
enum OthersType: Int, ProfileType, CaseIterable {
    case logout = 0
    case withdrawal
    
    var cellTitle: String {
        switch self {
        case .logout: return "로그아웃"
        case .withdrawal: return "회원탈퇴"
        }
    }
    var headerTitle: String {
        return "기타"
    }
}
