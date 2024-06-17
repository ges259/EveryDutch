//
//  FindFriendsVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 3/14/24.
//

import Foundation

protocol FindFriendsVMProtocol {
    var searchSuccessClosure: ((User) -> Void)? { get set }
    var inviteSuccessClosure: (() -> Void)? { get set }
    var apiErrorClosure: ((ErrorEnum) -> Void)? { get set }
    func searchUser(text: String?)
    
    func inviteUser()
}
