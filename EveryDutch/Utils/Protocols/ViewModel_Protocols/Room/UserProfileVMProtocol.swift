//
//  UserProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import Foundation

protocol UserProfileVMProtocol: ReceiptTableViewProtocol {
    var isRoomManager: Bool { get }
    
    var btnStvInsets: CGFloat { get }
    var getUserDecoTuple: UserDecoTuple? { get }
    
    
    var getUserReceiptLoadSuccess: Bool { get }
    func loadUserReceipt() 
    
    
    var isTableOpen: Bool { get set }
    var fetchSuccessClosure: (([IndexPath]) -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
}
