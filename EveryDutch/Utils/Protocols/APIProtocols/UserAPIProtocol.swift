//
//  UserAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol UserAPIProtocol: EditScreenAPIType {
    
    func readYourOwnUserData() async throws -> [String: User]

    func readUser(uid: String) async throws -> [String: User]
    
    func searchUser(_ userID: String) async throws -> [String: User]
    
    
    
    func updateUserProfileImage(
        imageUrl: String
    ) async throws
}
