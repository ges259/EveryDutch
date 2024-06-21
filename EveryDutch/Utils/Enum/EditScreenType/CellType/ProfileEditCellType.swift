//
//  ProfileEditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - ProfileEditCellType
enum ProfileEditCellType: Int, EditCellType, CaseIterable {
    case nickName = 0
    case personalID
    
    // MARK: - 유효성 검사
    static func validation(dict: [String: Any?]) -> [String] {
        return ProfileEditCellType.allCases.compactMap { caseItem in
            if !dict.keys.contains(caseItem.databaseString) {
                return caseItem.databaseString
            }
            return nil
        }
    }
    
    func saveTextData(data: Any?, to textData: inout [String: Any?]) {
        print("\(#function) ----- 1")
        textData[databaseString] = data
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
    
    
    // MARK: - Detail
    static func getDetails(data: EditProviderModel?) -> [(type: EditCellType, detail: String?)] {
        return ProfileEditCellType.allCases.map 
        { cellType -> (type: EditCellType, detail: String?) in
            return (type: cellType, detail: cellType.detail(for: data))
        }
    }
    private func detail(for user: EditProviderModel?) -> String? {
        guard let user = user as? User else { return nil }
        
        switch self {
        case .nickName: return user.userName
        case .personalID: return user.personalID
        }
    }
}
