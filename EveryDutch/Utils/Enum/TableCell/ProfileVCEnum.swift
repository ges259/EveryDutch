//
//  ProfileVCEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import Foundation

enum ProfileVCEnum: Int, CaseIterable {
    case userInfo = 0
    
    var sectionIndex: Int {
        return self.rawValue
    }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [ProfileCellType] {
        switch self {
        case .userInfo:     return UserInfoType.allCases
        }
    }
    
    func createProviders(user: User) -> [Int: [ProfileTypeCell]] {
        var allCellData: [Int: [ProfileTypeCell]] = [:]
        
        ProfileVCEnum.allCases.forEach { sectionEnum in
            
            switch sectionEnum {
            case .userInfo: 
                let tuples = UserInfoType.getDetails(data: user)
                allCellData[sectionEnum.sectionIndex] = tuples
                break
            }
            
        }
        return allCellData
    }
}



enum UserInfoType: Int, ProfileCellType, CaseIterable {
    case personalID = 0
    case nickName
    case profileImage
    
    static func getDetails(data: User) -> [ProfileTypeCell] {
        return UserInfoType.allCases.map { cellType -> ProfileTypeCell in
            return (type: cellType, 
                    detail: cellType.detail(from: data),
                    isText: cellType.isText)
        }
    }
    
    private func detail(from user: User?) -> String? {
        switch self {
        case .personalID: return user?.personalID
        case .nickName: return user?.userName
        case .profileImage: return user?.userProfileImage
        }
    }
    
    var cellTitle: String {
        switch self {
        case .personalID: return "계정 ID"
        case .nickName: return "닉네임"
        case .profileImage: return "프로필 사진"
        }
    }
    var headerTitle: String {
        return "회원 정보"
    }
    
    private var isText: Bool {
        switch self {
        case .personalID, .nickName:
            return true
        case .profileImage:
            return false
        }
    }
}
