//
//  profileEditEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import Foundation

// MARK: - EditScreenType

protocol EditScreenType {
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String { get }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String
    
    // MARK: - 푸터뷰 높이
    var footerViewHeight: CGFloat { get }
    
    // MARK: - 섹션의 인덱스
    var sectionIndex: Int { get }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [EditCellType] { get }
}

// MARK: - 공통 함수

extension EditScreenType {
    
    // MARK: - 바텀 버튼 타이틀
    func bottomBtnTitle(isMake: Bool) -> String? {
        return isMake
        ? "수정 완료"
        : "생성 완료"
    }
    
    // MARK: - 데코 관련 코드
    var cardHeaderTitle: String {
        return "카드 효과 설정"
    }
    var imageHeaderTitle: String {
        return "이미지 설정"
    }
}










// MARK: - ProfileEditEnum
enum ProfileEditEnum: Int, EditScreenType, CaseIterable {
    case userData = 0
    case imageData
    case cardDecoration
    
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
    
    // MARK: - 푸터뷰 높이
    var footerViewHeight: CGFloat {
        switch self {
        case .userData, .imageData:
            return 45
        case .cardDecoration:
            return 44
        }
    }
}










// MARK: - RoomEditEnum
enum RoomEditEnum: Int, EditScreenType, CaseIterable {
    case roomData = 0
    case imageData
    case cardDecoration
    
    
    // MARK: - rawValue 반환
    var sectionIndex: Int {
        return self.rawValue
    }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [EditCellType] {
        switch self {
        case .roomData:         return RoomEditCellType.allCases
        case .imageData:        return ImageCellType.allCases
        case .cardDecoration:   return DecorationCellType.allCases
        }
    }
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String {
        switch self {
        case .roomData:         return "정산방 정보"
        case .imageData:        return self.imageHeaderTitle
        case .cardDecoration:   return self.cardHeaderTitle
        }
    }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String {
        return isMake
        ? "정산방 생성"
        : "정산방 설정"
    }
    
    // MARK: - 푸터뷰 높이
    var footerViewHeight: CGFloat {
        switch self {
        case .roomData, .imageData:
            return 45
        case .cardDecoration:
            return 44
        }
    }
}



















// MARK: - EditCellType
protocol EditCellType {
    
    // MARK: - 셀 타이틀
    var getCellTitle: String { get }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String { get }
}





// MARK: - ProfileEditCellType
enum ProfileEditCellType: Int, EditCellType, CaseIterable {
    case nickName = 0
    case personalID
    
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
}





// MARK: - RoomEditCellType
enum RoomEditCellType: Int, EditCellType, CaseIterable {
    case roomName = 0
    case className
    case ManagerName
    
    // MARK: - 셀 타이틀
    var getCellTitle: String {
        switch self {
        case .roomName:     return "정산방 이름"
        case .className:    return "모임 이름"
        case .ManagerName:  return "총무 이름"
        }
    }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String {
        switch self {
        case .roomName:     return "정산방의 이름을 설정해 주세요."
        case .className:    return "모임의 이름을 설정해 주세요."
        case .ManagerName:  return "총무를 선택해 주세요."
        }
    }
}







enum ImageCellType: Int, EditCellType, CaseIterable {
    case profileImg = 0
    case backgroundImg
    
    
    var getCellTitle: String {
        switch self {
        case .profileImg:       return "프로필 이미지 변경"
        case .backgroundImg:    return "배경 이미지 변경"
        }
    }
    
    var getTextFieldPlaceholder: String {
        return ""
    }
}


// MARK: - DecorationCellType
enum DecorationCellType: Int, EditCellType, CaseIterable {
    case blurEffect = 0
    case titleColor
    case pointColor
    case backgourndColor
    
    // 공통으로 제공되는 cardDecorationTitle
    var getCellTitle: String {
        switch self {
        case .blurEffect:       return "블러효과 적용"
        case .titleColor:       return "글자 색상"
        case .pointColor:       return "포인트 색상"
        case .backgourndColor:  return "배경 색상"
        }
    }
    var getTextFieldPlaceholder: String {
        return ""
    }
}
