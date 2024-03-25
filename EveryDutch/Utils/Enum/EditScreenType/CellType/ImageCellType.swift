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
    
    var databaseString: String {
        switch self {
        case .profileImg: return DatabaseConstants.card_profile_image
        case .backgroundImg: return DatabaseConstants.card_background_image
        }
    }
    
    func detail(for data: Decoration?) -> String? {
        
        switch self {
        case .profileImg: return data?.profileImage ?? nil
        case .backgroundImg: return data?.backgroundImage ?? nil
        }
    }
}


import UIKit

struct Decoration {
    var blur: Bool
    var profileImage: String?
    var backgroundImage: String?
    var backgroundColor: String?
    var pointColor: String?
    var titleColor: String?
    
    // MARK: - Fix
    init(blur: Bool, 
         profileImage: String?,
         backgroundImage: String?,
         backgroundColor: String?,
         pointColor: String?,
         titleColor: String?)
    {
        self.blur = blur
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.backgroundColor = backgroundColor
        self.pointColor = pointColor
        self.titleColor = titleColor
    }
}
