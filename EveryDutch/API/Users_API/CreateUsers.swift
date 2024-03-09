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
    

    
    func createData(
        dict: [String: Any],
        completion: @escaping (Result<Rooms?, ErrorEnum>) -> Void)
    {
        
    }
    func updateData(dict: [String: Any]) {
        
    }
    
    
    
}
