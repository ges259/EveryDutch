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
    case nameColor
    
    // 공통으로 제공되는 cardDecorationTitle
    var getCellTitle: String {
        switch self {
        case .background:       return "배경 변경"
        case .blurEffect:       return "블러효과 적용"
        case .titleColor:       return "타이틀 색상 변경"
        case .nameColor:       return "이름 색상 변경"
        }
    }
    var getTextFieldPlaceholder: String {
        return ""
    }
    
    var databaseString: String {
        switch self {
        case .background: return DatabaseConstants.background_Data
        case .blurEffect: return DatabaseConstants.blur_Effect
        case .titleColor: return DatabaseConstants.title_Color
        case .nameColor: return DatabaseConstants.name_Color
        }
    }
    
    
    
    
    // MARK: - Detail
    static func getDetails(deco: Decoration?) -> [(type: EditCellType, detail: String?)] {
        return DecorationCellType.allCases.map { cellType -> (type: EditCellType, detail: String?) in
            return (type: cellType, detail: cellType.detail(for: deco))
        }
    }
    private func detail(for data: Decoration?) -> String? {
        switch self {
        case .background: return data?.backgroundImageUrl ?? nil
        case .blurEffect: return self.blurColor(bool: data?.blur)
        case .titleColor: return data?.titleColor
        case .nameColor: return data?.nameColor
        }
    }
    
    private func blurColor(bool: Bool?) -> String? {
        return bool ?? false ? "true" : "false"
    }
}
