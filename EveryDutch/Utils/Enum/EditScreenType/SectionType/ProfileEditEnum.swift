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
    case cardDecoration
    
    // MARK: - 셀 생성
    func createProviders(
        withData data: EditProviderModel?,
        decoration: Decoration?) -> [Int: [EditCellDataCell]]
    {
        var detailsDictionary: [Int: [EditCellDataCell]] = [:]
        
        RoomEditEnum.allCases.forEach { roomEditEnum in
            switch roomEditEnum {
            case .roomData:
                let roomEditCellTypes = ProfileEditCellType.getDetails(data: data)
                detailsDictionary[roomEditEnum.sectionIndex] = roomEditCellTypes
                
            case .cardDecoration:
                let decoEditCellTypes = DecorationCellType.getDetails(deco: decoration)
                detailsDictionary[roomEditEnum.sectionIndex] = decoEditCellTypes
            }
        }
        return detailsDictionary
    }
    
    // MARK: - 유효성 검사
    func validation(data: [String: Any?]) -> [String] {
        let profileValidation = ProfileEditCellType.validation(dict: data)
        // 추가적으로 다른 cellType에 유효성 검사가 필요할 경우,
        // profileValidation + decorationValidation
        // 해당 방식으로 사용
        return profileValidation
    }
    
    // MARK: - API 타입
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
        case .cardDecoration:   return DecorationCellType.allCases
        }
    }
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String {
        switch self {
        case .userData:       return "회원 정보"
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
