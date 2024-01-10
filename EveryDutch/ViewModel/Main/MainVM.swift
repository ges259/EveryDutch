//
//  MainVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class MainVM: MainVMProtocol {
    private var cellViewModels: [MainCollectionViewCellVM] = []
    
    
    
    var numberOfItems: Int {
        return self.cellViewModels.count
    }
    
    // 클로저
    var collectionVeiwReloadClousure: (() -> Void)?
    
    
    
    // MARK: - Fix
    // 1. 데이터를 받아서 cellViewModel에 넣는다.
    var rooms: [Rooms] = [] {
        didSet {
            // 예시 데이터 로드
            cellViewModels = self.rooms.map {
                MainCollectionViewCellVM(title: $0.roomName,
                                         imgUrl: $0.roomImg )
            }
            self.collectionVeiwReloadClousure?()
        }
    }
    
    
    init() {
        RoomsAPI.shared.readRooms { result in
            switch result {
            case .success(let rooms):
                self.rooms = rooms
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
    }
    
    func ddd() {
        
    }
    
    
    
    // cellViewModels 반환
     func cellViewModel(at index: Int) -> MainCollectionViewCellVM {
         return self.cellViewModels[index]
     }


}
