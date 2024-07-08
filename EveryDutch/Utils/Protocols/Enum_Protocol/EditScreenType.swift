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
    func createProviders(
        withData data: EditProviderModel?,
        decoration: Decoration?) -> [Int: [EditCellTypeTuple]]
    func validation(data: [String: Any?]) -> [String]
    
    var apiType: EditScreenAPIType { get }
    
    // MARK: - 헤더 타이틀
    var getHeaderTitle: String { get }
    
    // MARK: - 네비게이션 타이틀
    func getNavTitle(isMake: Bool) -> String
    
    // MARK: - 섹션의 인덱스
    var sectionIndex: Int { get }
    
    
    func validatePersonalID(
        api: EditScreenAPIType?,
        textData: [String: Any?]
    ) async throws
}


extension EditScreenType {
    
    func validatePersonalID(
        api: EditScreenAPIType?,
        textData: [String: Any?]
    ) async throws {
        // 개인 ID 중복 확인 로직 구현
        print("validatePersonalID called but not implemented.")
    }
}
