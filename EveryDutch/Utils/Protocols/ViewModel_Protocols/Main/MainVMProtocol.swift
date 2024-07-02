//
//  MainVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainVMProtocol {
    
    var numberOfRooms: Int { get }
    func cellViewModel(at index: Int) -> MainCollectionViewCellVMProtocol?
    
    func itemTapped(index: Int)
    var moveToSettleMoneyRoomClosure: (() -> Void)? { get set }
    
    

    // 바뀐 인덱스패스 데이터 저장
    func userDataChanged(_ userInfo: [String: Any])
    // 뷰모델에 저장된 변경 사항 반환
    func getPendingUpdates() -> [String: [IndexPath]]
    // 모든 대기 중인 변경 사항 초기화
    func resetPendingUpdates()
}
