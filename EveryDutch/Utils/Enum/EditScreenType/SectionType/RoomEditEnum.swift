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
    
    // MARK: - 셀 생성
    func createProviders(
        withData data: EditProviderModel?,
        decoration: Decoration?) -> [Int: [EditCellTypeTuple]]
    {
        var detailsDictionary: [Int: [EditCellTypeTuple]] = [:]
        
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
    
    // MARK: - 유효성 검사
    func validation(data: [String: Any?]) -> [String] {
        let roomValidation = RoomEditCellType.validation(dict: data)
        // 추가적으로 다른 cellType에 유효성 검사가 필요할 경우,
        // roomValidation + decorationValidation
        // 해당 방식으로 사용
        return roomValidation
    }
    
    // MARK: - API 타입
    var apiType: EditScreenAPIType {
        return RoomsAPI.shared
    }
    
    // MARK: - rawValue 반환
    var sectionIndex: Int {
        return self.rawValue
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
