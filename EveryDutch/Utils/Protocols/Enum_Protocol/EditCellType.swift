//
//  EditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - EditCellType
protocol EditCellType {
    
    // MARK: - 셀 타이틀
    var getCellTitle: String { get }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String { get }
    
    var databaseString: String { get }
}
