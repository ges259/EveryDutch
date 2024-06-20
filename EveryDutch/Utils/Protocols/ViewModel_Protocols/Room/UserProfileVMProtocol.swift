//
//  UserProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import UIKit

protocol UserProfileVMProtocol: ReceiptTableViewProtocol {
    // 클로저
    var fetchSuccessClosure: (([IndexPath]) -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    var searchModeClosure: ((UIImage?, String) -> Void)? { get set }
    
    // 플래그 변경
    func disableMoreUserReceiptDataLoading()
    func markNoDataAvailable()
    func setTableOpenState(_ isOpen: Bool)
    
    // 데이터 리턴
    var isTableOpen: Bool { get }
    var hasNoData: Bool { get }
    var getUserReceiptLoadSuccess: Bool { get }
    var isRoomManager: Bool { get }
    var getUserDecoTuple: UserDecoTuple? { get }
    
    // API
    func loadUserReceipt()
}
