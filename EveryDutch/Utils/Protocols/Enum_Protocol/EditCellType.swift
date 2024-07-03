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
    
//    var rawValueIndex: Int { get }
    
    
    func saveTextData(data: Any?, to textData: inout [String: Any?])
    
    func saveDecorationData(data: Any?, to decorationData: inout [String: Any?]) 
}
extension EditCellType {
    func saveTextData(
        data: Any?,
        to textData: inout [String: Any?]
    ) {
        // 옵셔널바인딩 실패, 비어있는 상태라면, 지우기
        if let text = data as? String,
           text == "" {
            textData.removeValue(forKey: databaseString)
        } else {
            textData[databaseString] = data
        }
    }

    func saveDecorationData(
        data: Any?,
        to decorationData: inout [String: Any?]
    ) {
        // 기본 구현 (아무것도 하지 않음)
        print("\(#function) --- 구현 안 됨")
    }
}
