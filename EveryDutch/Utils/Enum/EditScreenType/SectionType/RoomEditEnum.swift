//
//  RoomEditEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import Foundation

// MARK: - RoomEditEnum
enum RoomEditEnum: Int, EditScreenType, CaseIterable {
    case roomData = 0
    case cardDecoration
    
    
    func createProviders(
        withData data: EditProviderModel?,
        decoration: Decoration?) -> [Int: [EditCellDataCell]]
    {
        var detailsDictionary: [Int: [EditCellDataCell]] = [:]
        
        RoomEditEnum.allCases.forEach { roomEditEnum in
            switch roomEditEnum {
            case .roomData:
                let roomEditCellTypes = RoomEditCellType.getDetails(data: data)
                detailsDictionary[roomEditEnum.sectionIndex] = roomEditCellTypes
                
            case .cardDecoration:
                let decoEditCellTypes = DecorationCellType.getDetails(deco: decoration)
                detailsDictionary[roomEditEnum.sectionIndex] = decoEditCellTypes
            }
        }
        return detailsDictionary
    }
    
    
    
    
    
    
    var apiType: EditScreenAPIType {
        return RoomsAPI.shared
    }
    
    
    
    // MARK: - rawValue 반환
    var sectionIndex: Int {
        return self.rawValue
    }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [EditCellType] {
        switch self {
        case .roomData:         return RoomEditCellType.allCases
        case .cardDecoration:   return DecorationCellType.allCases
        }
    }
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String {
        switch self {
        case .roomData:         return "정산방 정보"
        case .cardDecoration:   return self.cardHeaderTitle
        }
    }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String {
        return isMake
        ? "정산방 생성"
        : "정산방 설정"
    }
}
