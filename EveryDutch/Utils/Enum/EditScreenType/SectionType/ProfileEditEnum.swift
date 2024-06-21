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
        decoration: Decoration?) -> [Int: [EditCellTypeTuple]]
    {
        var detailsDictionary: [Int: [EditCellTypeTuple]] = [:]
        
        ProfileEditEnum.allCases.forEach { roomEditEnum in
            switch roomEditEnum {
            case .userData:
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
    func validatePersonalID(
        api: EditScreenAPIType?,
        textData: [String: Any?]
    ) async throws {
        // 개인 ID 중복 확인 로직 구현
        // textData에서 personal_ID를 가져옴
        // userID도 가져옴
        guard let personalID = textData[DatabaseConstants.personal_ID] as? String,
              let userID = api?.getCurrentUserID
        else { throw ErrorEnum.readError }
        // personal_ID가 중복되어있는지 확인
        let isExists = try await api?.validatePersonalID(
            userID: userID,
            personalID: personalID) ?? false
        // 이미 존재한다면(중복이라면), throw
        if isExists {
            throw ErrorEnum.validationError([DatabaseConstants.duplicatePersonalID] )
        }
    }
    
    // MARK: - API 타입
    var apiType: EditScreenAPIType {
        return UserAPI.shared
    }
    
    // MARK: - rawValue 반환
    var sectionIndex: Int {
        return self.rawValue
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
