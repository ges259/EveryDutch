//
//  EditScreenAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/6/24.
//

import Foundation

protocol EditScreenAPIType: DecorationAPIType {
    func createData(dict: [String: Any]) async throws -> String
    
    func updateData(IdRef: String, dict: [String: Any]) async throws
    
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
}
