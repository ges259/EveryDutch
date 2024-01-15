//
//  UserAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol UserAPIProtocol {
    static var shared: UserAPI { get }
    
    // typealias
    typealias UserCompletion = (Result<User, ErrorEnum>) -> Void
    
    
    func readUser(completion: @escaping UserCompletion)
    
    
    
    
    
}