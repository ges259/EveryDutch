//
//  DecorationCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import UIKit

// MARK: - DecorationCellType
enum DecorationCellType: Int, EditCellType, CaseIterable {
    case blurEffect = 0
    case titleColor
    case pointColor
    case backgroundColor
    
    // 공통으로 제공되는 cardDecorationTitle
    var getCellTitle: String {
        switch self {
        case .blurEffect:       return "블러효과 적용"
        case .titleColor:       return "글자 색상"
        case .pointColor:       return "포인트 색상"
        case .backgroundColor:  return "배경 색상"
        }
    }
    var getTextFieldPlaceholder: String {
        return ""
    }
    
    var databaseString: String {
        switch self {
        case .blurEffect: return DatabaseConstants.blur_Effect
        case .titleColor: return DatabaseConstants.title_Color
        case .pointColor: return DatabaseConstants.point_Color
        case .backgroundColor: return DatabaseConstants.background_Color
        }
    }
    
    
    
    func detail(for data: Decoration?) -> String? {
        switch self {
        case .blurEffect: return self.blurColor(bool: data?.blur)
        case .titleColor: return data?.titleColor
        case .pointColor: return data?.pointColor
        case .backgroundColor: return data?.backgroundColor
        }
    }
    
    private func blurColor(bool: Bool?) -> String? {
        return bool ?? false ? "true" : "false"
    }
}
