//
//  ProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import Foundation

protocol ProfileVMProtocol {
    
    var getUserID: String { get }
    
    var userDataClosure: ((User) -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    func initializeUserData() 
    
    
    
    var getNumOfSection: Int { get }
    
    func getNumOfCell(section: Int) -> Int
    
    
    func getFooterViewHeight(section: Int) -> CGFloat
    func getHeaderTitle(section: Int) -> String?
    
    func getCellData(indexPath: IndexPath) -> ProfileTypeCell?
}
