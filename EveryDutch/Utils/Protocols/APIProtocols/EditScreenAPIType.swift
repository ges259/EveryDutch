//
//  EditScreenAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/6/24.
//

import Foundation

protocol EditScreenAPIType {
    func createScreen(dict: [String: Any],
                      completion: @escaping (Result<Void, ErrorEnum>) -> Void)
    func updateScreen(dict: [String: Any])
}
