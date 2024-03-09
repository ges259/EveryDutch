//
//  EditScreenAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/6/24.
//

import Foundation

protocol EditScreenAPIType {
    func createData(
        dict: [String: Any],
        completion: @escaping (Result<Rooms?, ErrorEnum>) -> Void)
    func updateData(dict: [String: Any])
}
