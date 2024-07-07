//
//  ProfileVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

protocol ProfileVMProtocol {
    
    
    
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    
    var profileImageCellIndexPath: IndexPath? { get }
    var userDecoTuple: UserDecoTuple? { get }
    
    var getNumOfSection: Int { get }
    
    func getNumOfCell(section: Int) -> Int
    
    
    func getFooterViewHeight(section: Int) -> CGFloat
    func getHeaderTitle(section: Int) -> String?
    
    func getCellData(indexPath: IndexPath) -> ProfileTypeCell?
    
    
    
    var getProviderTuple: ProviderTuple? { get }
    
    
    func saveProfileImage(_ image: UIImage)
}
