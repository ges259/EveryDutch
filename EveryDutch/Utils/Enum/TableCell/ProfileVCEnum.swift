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
    
    
    
    // MARK: - 데이터 생성 로직 수정
    static func makeDataCellData(user: User) -> [ProfileDataCell] {
        var cellDataArray: [ProfileDataCell] = []
        
        // 모든 섹션에 대한 데이터 생성
        for sectionEnum in ProfileVCEnum.allCases {
            // 각 섹션에 대한 모든 셀 타입 처리
            let sectionCellData: [ProfileDataCell] = sectionEnum.getAllOfCellType.compactMap { cellType -> ProfileDataCell? in
                
                
                // detail 정보는 UserInfoType에 대해서만 user 데이터를 사용
                switch cellType {
                case let userInfoType as UserInfoType:
                    let detail = userInfoType.detail(from: user)
                    return (type: userInfoType, detail: detail)
                    
                case let userInfoType as OthersType:
                    // OthersType에 대한 상세 정보는 현재 사용자 데이터와 무관하므로 nil 할당 가능
                    // 예를 들어, "로그아웃" 또는 "회원탈퇴" 같은 경우에는 user 데이터가 필요하지 않음
                    return (type: cellType, detail: nil)
                    
                default:
                    return nil
                }
            }
            cellDataArray.append(contentsOf: sectionCellData)
        }
        
        return cellDataArray
    }
    
    

}
enum UserInfoType: Int, ProfileType, CaseIterable {
    case personalID = 0
    case nickName
    
    

    
    func detail(from user: User) -> String {
        switch self {
        case .personalID: return user.personalID
        case .nickName: return user.userName
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
protocol ProfileType {
    var cellTitle: String { get }
    var headerTitle: String { get }
}


typealias ProfileDataCell = (type: ProfileType, detail: String?)
