//
//  RoomEditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - RoomEditCellType
enum RoomEditCellType: Int, EditCellType, ValidationType, CaseIterable {
    case roomName = 0
    case className
    case ManagerName
    
    func validation(dict: [String: Any?]) -> [String] {
        return RoomEditCellType.allCases.compactMap { caseItem in
            if !dict.keys.contains(caseItem.databaseString) {
                print("1111")
                return caseItem.databaseString
            } else {
                print("2222")
            }
            return nil
        }
    }
    
    
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
        case .className: return DatabaseConstants.manager_name
        case .ManagerName: return DatabaseConstants.manager_name
        }
    }
    
    static func getDetails(data: EditProviderModel?) -> [(type: EditCellType, detail: String?)] {
        return RoomEditCellType.allCases.map { cellType -> (type: EditCellType, detail: String?) in
            return (type: cellType, detail: cellType.detail(for: data))
        }
    }
    
    func detail(for room: EditProviderModel?) -> String? {
        guard let room = room as? Rooms else { return nil }
        switch self {
        case .roomName: return room.roomName
        case .className: return room.roomName
        case .ManagerName: return room.versionID
        }
    }
}
