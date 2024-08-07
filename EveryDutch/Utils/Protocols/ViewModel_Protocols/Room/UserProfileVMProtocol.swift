//
//  UserProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import UIKit

protocol UserProfileVMProtocol {
    // 클로저
//    var fetchSuccessClosure: (([IndexPath]) -> Void)? { get set }
    var userReceiptInitialLoad: Bool { get }
    
    
    
    
    
    
    var deleteUserSuccessClosure: (() -> Void)? { get set }
    var reportSuccessClosure: ((AlertEnum, Int) -> Void)? { get set }
    var searchModeClosure: ((UIImage?, String) -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    
    // 플래그 변경
    func disableMoreUserReceiptDataLoading()
    func markNoDataAvailable()
    func setTableOpenState(_ isOpen: Bool)
    
    // 데이터 리턴
    var isTableOpen: Bool { get }
    var hasNoData: Bool { get }
    
    var isRoomManager: Bool { get }
    var currentUserIsEuqualToMyUid: Bool { get }
    var getUserDecoTuple: UserDecoTuple? { get }
    
//    var getUserReceiptLoadSuccess: Bool { get }
    
    
    
    /// 특정 유저를 신고하는 메서드
    func reportUser()
    
    /// '방장'이 특정 유저를 강퇴시키는 메서드
    func kickUser()
    
    
    
    
    // MARK: - 영수증 데이터
    func loadReceiptData()
    func loadMoreReceiptData()
}
