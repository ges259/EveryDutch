//
//  ProfileEditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

protocol ValidationType {
    func validation(dict: [String: Any?]) -> [String]
}


// MARK: - ProfileEditCellType
enum ProfileEditCellType: Int, EditCellType, ValidationType, CaseIterable {
    case nickName = 0
    case personalID
    
    func validation(dict: [String: Any?]) -> [String] {
        return ProfileEditCellType.allCases.compactMap { caseItem in
            if !dict.keys.contains(caseItem.databaseString) {
                print("1111")
                return caseItem.databaseString
            } else {
                print("2222")
            }
            return nil
        }
    }
    
    
    // MARK: - 셀 타이틀
    var getCellTitle: String {
        switch self {
        case .nickName:     return "닉네임"
        case .personalID:   return "개인 ID"
        }
    }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String {
        switch self {
        case .nickName:     return "닉네임을 설정해 주세요."
        case .personalID:   return "개인 ID를 설정해 주세요."
        }
    }
    
    var databaseString: String {
        switch self {
        case .nickName: return DatabaseConstants.user_name
        case .personalID: return DatabaseConstants.personal_ID
        }
    }
    
    func detail(for user: User?) -> String? {
        switch self {
        case .nickName: return user?.userName
        case .personalID: return user?.personalID
        }
    }
}
