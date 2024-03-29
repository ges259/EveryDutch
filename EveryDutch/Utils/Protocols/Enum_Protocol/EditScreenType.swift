//
//  EditScreenType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation
//associatedtype typeData: Any
// MARK: - EditScreenType

protocol EditScreenType {
    
//    associatedtype validationType: EditCellType
//    
//    func getType() -> validationType.Type
//
    func createProviders(withData data: ProviderModel?, decoration: Decoration?) -> [DataProvider]

    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String { get }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String
    
    // MARK: - 섹션의 인덱스
    var sectionIndex: Int { get }
    
    // MARK: - 셀 타입 반환
    var getAllOfCellType: [EditCellType] { get }
}
