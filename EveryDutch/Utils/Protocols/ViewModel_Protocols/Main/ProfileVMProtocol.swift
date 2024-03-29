//
//  ProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import Foundation

protocol ProfileVMProtocol {
    
    var getNumOfSection: Int { get }
    
    func getNumOfCell(section: Int) -> Int
    
    
    func getFooterViewHeight(section: Int) -> CGFloat
    func getHeaderTitle(section: Int) -> String
    
    
    func getTableData(section: Int, index: Int) -> String
}
