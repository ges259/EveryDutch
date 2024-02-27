//
//  profileEditEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import Foundation

// MARK: - CellTitleProvider
protocol CellTitleProvider {
    var getHeaderTitle: String { get }
    var getCellTitle: [String] { get }
    
    func getBottomBtnTitle(isMake: Bool) -> String
    
    func getNavTitle(isMake: Bool) -> String
    
    func getTextFieldPlaceholder(index: Int) ->  String
}
extension CellTitleProvider {
    
    // 공통으로 제공되는 cardDecorationTitle
    var cardDecorationTitle: [String] {
        return ["블러효과 적용",
                "글자 색상",
                "포인트 색상",
                "배경 색상"]
    }
    var cardHeaderTitle: String {
        return "카드 설정"
    }
}




enum typedd {
    case profileEdit(ProfileEditEnum)
    case roomEdit(RoomEditEnum)
}





// MARK: - ProfileEditEnum
enum ProfileEditEnum: CaseIterable, CellTitleProvider {
    case userData
    case cardDecoration
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String {
        switch self {
        case .userData:
            return "회원 정보"
        case .cardDecoration:
            return self.cardHeaderTitle
        }
    }
    
    // MARK: - 셀 타이틀
    var getCellTitle: [String] {
        switch self {
        case .userData:
            return ["닉네임",
                    "개인 ID"]
        case .cardDecoration:
            return self.cardDecorationTitle
        }
    }
    
    // MARK: - 플레이스홀더
    func getTextFieldPlaceholder(index: Int) ->  String {
        
        let placeholderArray = ["닉네임을 설정해 주세요.",
                                "개인 ID를 설정해 주세요."]
        
        guard index < placeholderArray.count else { return "" }
        
        return placeholderArray[index]
    }
    
    // MARK: - 바텀 버튼 타이틀
    func getBottomBtnTitle(isMake: Bool) -> String {
        return isMake
        ? "완료"
        : "수정 완료"
    }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String {
        return isMake
        ? "프로필 생성"
        : "프로필 설정"
    }
}










// MARK: - RoomEditEnum
enum RoomEditEnum: CaseIterable, CellTitleProvider {
    case roomData
    case cardDecoration
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String {
        switch self {
        case .roomData:
            return "정산방 정보"
        case .cardDecoration:
            return self.cardHeaderTitle
        }
    }
    
    // MARK: - 셀 타이틀
    var getCellTitle: [String] {
        switch self {
        case .roomData:
            return ["정산방 이름",
                    "모임 이름",
                    "총무 이름"]
        case .cardDecoration:
            return self.cardDecorationTitle
        }
    }
    
    // MARK: - 플레이스홀더
    func getTextFieldPlaceholder(index: Int) ->  String {
        
        let placeholderArray = ["정산방의 이름을 설정해 주세요.",
                                "모임의 이름을 설정해 주세요.",
                                "총무를 선택해 주세요."]
        
        guard index < placeholderArray.count else { return "" }
        
        return placeholderArray[index]
    }
    
    // MARK: - 바텀 버튼 타이틀
    func getBottomBtnTitle(isMake: Bool) -> String {
        return isMake
        ? "완료"
        : "수정 완료"
    }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String {
        return isMake
        ? "정산방 생성"
        : "정산방 설정"
    }
}
