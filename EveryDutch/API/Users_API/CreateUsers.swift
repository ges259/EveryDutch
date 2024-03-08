//
//  CreateUsers.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

struct UserAPI: UserAPIProtocol {
    static let shared: UserAPIProtocol = UserAPI()
    private init() {}
    

    
    func createScreen(
        dict: [String: Any],
        completion: @escaping (Result<Void, ErrorEnum>) -> Void)
    {
        
    }
    func updateScreen(dict: [String: Any]) {
        
    }
    
    
    
}
