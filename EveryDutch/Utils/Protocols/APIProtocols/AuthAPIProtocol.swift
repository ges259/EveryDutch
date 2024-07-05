//
//  AuthAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 3/13/24.
//

import Foundation

protocol AuthAPIProtocol {
    func checkLogin() async throws
    func signInAnonymously() async throws 
}
