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
    // (type: ProfileType, detail: String?)
//    func createProviders(user: User) -> [Int: [ProfileDataCell]] {
//        var allCellData: [Int: [ProfileDataCell]] = [:]
//        
//        ProfileVCEnum.allCases.forEach { sectionEnum in
//            
//            let cellData = sectionEnum.getAllOfCellType.compactMap { cellType -> ProfileDataCell? in
//                switch cellType {
//                case let userInfoType as UserInfoType:
//                    let detail = userInfoType.detail(from: user)
//                    return (type: userInfoType, detail: detail)
//                    
//                case let othersType as OthersType:
//                    // 필요에 따라 기본값 또는 다른 로직을 추가할 수 있습니다.
//                    return (type: othersType, detail: nil)
//                    
//                default:
//                    return nil
//                }
//            }
//            allCellData[sectionEnum.sectionIndex] = cellData
//        }
//        return allCellData
//    }
    func createProviders(user: User) -> [Int: [ProfileDataCell]] {
        var allCellData: [Int: [ProfileDataCell]] = [:]
        
        ProfileVCEnum.allCases.forEach { sectionEnum in
            
            switch sectionEnum {
            case .userInfo: 
                let tuples = UserInfoType.getDetails(data: user)
                allCellData[sectionEnum.sectionIndex] = tuples
                break
            case .others:
                let tuples = OthersType.getDetails()
                allCellData[sectionEnum.sectionIndex] = tuples
                break
            }
            
        }
        return allCellData
    }
}



enum UserInfoType: Int, ProfileType, CaseIterable {
    case personalID = 0
    case nickName
    
    static func getDetails(data: User) -> [ProfileDataCell] {
        return UserInfoType.allCases.map { cellType -> ProfileDataCell in
            return (type: cellType, detail: cellType.detail(from: data))
        }
    }
    
    func detail(from user: User?) -> String? {
        switch self {
        case .personalID: return user?.personalID
        case .nickName: return user?.userName
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
    
    static func getDetails() -> [ProfileDataCell] {
        return OthersType.allCases.map { cellType -> ProfileDataCell in
            return (type: cellType, detail: nil)
        }
    }
    
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
