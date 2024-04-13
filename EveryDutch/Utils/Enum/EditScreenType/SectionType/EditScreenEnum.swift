//
//  profileEditEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import Foundation

// MARK: - ProfileEditEnum
enum ProfileEditEnum: Int, EditScreenType, CaseIterable {
    case userData = 0
    case imageData
    case cardDecoration
    
    
    
    func createProviders(
        withData data: EditProviderModel?,
        decoration: Decoration?) -> [EditDataProvider]
    {
        
        return [
            UserDataProvider(userData: data as? User),
            DecorationDataProvider(decorationData: decoration)
        ]
    }
    
    
    
    
    
    func validataionData(data: [String: Any]) -> Bool {
        return ProfileEditCellType.allCases.allSatisfy { data.keys.contains($0.databaseString) }
    }
    
    
    var apiType: EditScreenAPIType {
        return UserAPI.shared
    }
    
    
    
    
    // MARK: - rawValue 반환
    var sectionIndex: Int {
        return self.rawValue
    }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [EditCellType] {
        switch self {
        case .userData:         return ProfileEditCellType.allCases
        case .imageData:        return ImageCellType.allCases
        case .cardDecoration:   return DecorationCellType.allCases
        }
    }
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String {
        switch self {
        case .userData:       return "회원 정보"
        case .imageData:      return self.imageHeaderTitle
        case .cardDecoration: return self.cardHeaderTitle
        }
    }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String {
        return isMake
        ? "프로필 생성"
        : "프로필 설정"
    }
}
