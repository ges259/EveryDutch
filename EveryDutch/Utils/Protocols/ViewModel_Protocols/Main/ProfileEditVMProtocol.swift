//
//  ChatSettingProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol ProfileEditVMProtocol {
    
    
    
    var bottomBtn_Title: String? { get }
    
    
    
    
    
    var getNumOfSection: Int { get }
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat
    // MARK: - 섹션 당 데이터 개수
    func getNumOfCell(section: Int) -> Int
    
    // MARK: - 테이블 데이터
    func getTableData(section: Int, index: Int) -> String
}
