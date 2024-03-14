//
//  FindFriendsVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 3/14/24.
//

import Foundation

protocol FindFriendsVMProtocol {
    var searchSuccessClosure: ((User) -> Void)? { get set }
    var searchFailedClosure: (() -> Void)? { get set }
    
    func searchUser(text: String?)
}
