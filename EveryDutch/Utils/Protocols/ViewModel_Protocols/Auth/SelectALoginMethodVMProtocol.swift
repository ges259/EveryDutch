//
//  SelectALoginMethodVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import Foundation

protocol SelectALoginMethodVMProtocol {
    func signInAnonymously(completion: @escaping (Result<Void, ErrorEnum>) -> Void)
}
