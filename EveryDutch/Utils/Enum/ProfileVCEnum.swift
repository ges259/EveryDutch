//
//  ProfileVCEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import Foundation

enum ProfileVCEnum {
    case userInfo
    case others
    
    var title: String {
        switch self {
        case .userInfo: return "회원 정보"
        case .others: return "기타"
        }
    }
    
    var tableData: [(String, String)]? {
        switch self {
        case .userInfo: 
            return [("계정 ID", "dsjfaK23fds33"),
                    ("닉네임", "김게임성")]
            
        case .others:
            return [("로그아웃", ""),
                    ("회원탈퇴", ""),
                    ("1111", ""),
                    ("2222", ""),
                    ("3333", "")]
        }
    }
    /*

     */
    
    
}
