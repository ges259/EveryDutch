//
//  ProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileVM: ProfileVMProtocol {
    
    private let section: [ProfileVCEnum] = [.userInfo, .others]
    
    var getNumOfSection: Int {
        return self.section.count
    }
    
    
    
    
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    func getFooterViewHeight(section: Int) -> CGFloat {
        let tableData = self.section[section].tableData
        let count = tableData?.count ?? 0
        
        return count < 3 ? 50 : 5
    }
    
    
    
    
    
    func getNumOfTableData(section: Int) -> Int {
        let tableData = self.section[section].tableData
        return tableData?.count ?? 0
    }
    
    

    func getHeaderTitle(section: Int) -> String {
        return self.section[section].title 
    }
    
    
    func getTableData(section: Int, index: Int) -> (String, String)? {
        let tableData: [(String, String)]? = self.section[section].tableData
        return tableData?[index]
    }
}
