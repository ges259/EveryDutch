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
    func addedRoom(room: Rooms) -> IndexPath 
    
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
    
    func cellViewModel(at index: Int) -> MainCollectionViewCellVM
}
