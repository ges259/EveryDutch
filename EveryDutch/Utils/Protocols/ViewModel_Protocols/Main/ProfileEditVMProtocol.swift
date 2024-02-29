//
//  ChatSettingProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol ProfileEditVMProtocol {
    
//    func getPlaceholderTitle(index: Int) -> String?
    
    var getBottomBtnTitle: String? { get }
    
    var getNavTitle: String? { get }
    
    
    
    var getNumOfSection: Int { get }
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat
    // MARK: - 섹션 당 데이터 개수
    func getNumOfCell(section: Int) -> Int
    
    // MARK: - 셀에 사용할 타입 반환
    func cellTypes(indexPath: IndexPath) -> EditCellType?
    
    
    func getLastCell(indexPath: IndexPath) -> Bool
}
