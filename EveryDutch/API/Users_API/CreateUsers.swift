//
//  CreateUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

struct UserAPI {
    static let shared: UserAPI = UserAPI()
    private init() {}
    
    // typealias
    typealias UserCompletion = (Result<User, ErrorEnum>) -> Void
    
    
    
    
    
}
