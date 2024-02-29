//
//  DecorationCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

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
