//
//  MainCollectionViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import Foundation

protocol MainCollectionViewCellVMProtocol {

    
    // MARK: - 데이터 반환
    var getRoom: Rooms { get }
    var getRoomID: String { get }
    var getDecoration: Decoration? { get }
    
    
    // MARK: - 데이터 업데이트
    mutating func setupDecoration(deco: Decoration?)
    mutating func removeDecoration()
    
    mutating func updateDecoration(_ data: [String: Any])
    mutating func updateRoomData(_ data: [String: Any])
}
