//
//  AuthAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 3/13/24.
//

import Foundation

protocol AuthAPIProtocol {
    func checkLogin(completion: @escaping Typealias.VoidCompletion)
    
    func signInAnonymously(completion: @escaping Typealias.VoidCompletion)
}
