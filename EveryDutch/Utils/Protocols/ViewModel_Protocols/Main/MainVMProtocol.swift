//
//  MainVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainVMProtocol {
    var rooms: [Rooms] { get }
    var numberOfItems: Int { get }
    var collectionVeiwReloadClousure: (() -> Void)? { get set }
    
    func cellViewModel(at index: Int) -> MainCollectionViewCellVM
}
