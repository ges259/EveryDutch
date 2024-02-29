//
//  ImageCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - ImageCellType
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
