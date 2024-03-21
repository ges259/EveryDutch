//
//  RoomEditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - RoomEditCellType
enum RoomEditCellType: Int, EditCellType, CaseIterable {
    case roomName = 0
    case className
    case ManagerName
    
    // MARK: - 셀 타이틀
    var getCellTitle: String {
        switch self {
        case .roomName:     return "정산방 이름"
        case .className:    return "모임 이름"
        case .ManagerName:  return "총무 이름"
        }
    }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String {
        switch self {
        case .roomName:     return "정산방의 이름을 설정해 주세요."
        case .className:    return "모임의 이름을 설정해 주세요."
        case .ManagerName:  return "총무를 선택해 주세요."
        }
    }
    
    var databaseString: String {
        switch self {
        case .roomName: return DatabaseConstants.room_name
        case .className: return DatabaseConstants.class_name
        case .ManagerName: return DatabaseConstants.manager_name
        }
    }
}
