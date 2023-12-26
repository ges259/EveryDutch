//
//  MainVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol MainVMProtocol {
    
    var numberOfItems: Int { get }
    
    
    func cellViewModel(at index: Int) -> CollectionViewCellVM
}
