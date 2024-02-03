//
//  ProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileVM: ProfileVMProtocol {
    
    private let section: [ProfileVCEnum] = ProfileVCEnum.allCases
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int {
        return self.section.count
    }
    
    
    
    
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String {
        return self.section[section].headerTitle
    }
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        let tableData = self.section[section].cellTitle
        let count = tableData.count
        
        return count < 3 ? 50 : 5
    }
    
    // MARK: - 섹션 당 데이터 개수
    func getNumOfCell(section: Int) -> Int {
        let tableData = self.section[section].cellTitle
        return tableData.count
    }
    
    // MARK: - 테이블 데이터
    func getTableData(section: Int, index: Int) -> String {
        let tableData: [String] = self.section[section].cellTitle
        return tableData[index]
    }
}
