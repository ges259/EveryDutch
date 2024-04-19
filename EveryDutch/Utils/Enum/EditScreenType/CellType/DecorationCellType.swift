//
//  DecorationCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import UIKit

// MARK: - DecorationCellType
enum DecorationCellType: Int, EditCellType, CaseIterable {
    case background = 0
    case blurEffect
    case titleColor
    case pointColor
    
    // 공통으로 제공되는 cardDecorationTitle
    var getCellTitle: String {
        switch self {
        case .background:    return "배경 이미지 변경"
        case .blurEffect:       return "블러효과 적용"
        case .titleColor:       return "글자 색상"
        case .pointColor:       return "포인트 색상"
        }
    }
    var getTextFieldPlaceholder: String {
        return ""
    }
    
    var databaseString: String {
        switch self {
        case .background: return DatabaseConstants.card_background_image
        case .blurEffect: return DatabaseConstants.blur_Effect
        case .titleColor: return DatabaseConstants.title_Color
        case .pointColor: return DatabaseConstants.point_Color
        }
    }
    
    
    
    func detail(for data: Decoration?) -> String? {
        switch self {
        case .background: return data?.backgroundImage ?? nil
        case .blurEffect: return self.blurColor(bool: data?.blur)
        case .titleColor: return data?.titleColor
        case .pointColor: return data?.pointColor
        }
    }
    
    private func blurColor(bool: Bool?) -> String? {
        return bool ?? false ? "true" : "false"
    }
}
