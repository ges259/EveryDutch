//
//  MainVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainVMProtocol {
//    var rooms: [Rooms] { get }
    func itemTapped(index: Int)
    
//    var isFloatingShow: Bool { get set }
    var getSpinRotation: CGAffineTransform { get }
//    var onFloatingShowChanged: (() -> Void)? { get set }
    var onFloatingShowChanged: ((floatingType) -> Void)? { get set }
    
    
    func toggleFloatingShow()
    var getMenuBtnImg: UIImage? { get }
    
    
    var getBtnTransform: CGAffineTransform { get }
    
    
    var getIsFloatingStatus: Bool { get }
    
    
    
    var numberOfItems: Int { get }
    var collectionVeiwReloadClousure: (() -> Void)? { get set }
    
    func cellViewModel(at index: Int) -> MainCollectionViewCellVMProtocol
    
    
    
    
    

    // 바뀐 인덱스패스 데이터 저장
    func userDataChanged(_ userInfo: [String: [IndexPath]])
    // 뷰모델에 저장된 변경 사항 반환
    func getPendingUpdates() -> [String: [IndexPath]]
    // 모든 대기 중인 변경 사항 초기화
    func resetPendingUpdates()
}
