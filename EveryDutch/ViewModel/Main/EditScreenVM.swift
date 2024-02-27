//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class EditScreenVM<Section: CellTitleProvider & CaseIterable> : ProfileEditVMProtocol {
    
    
    
    private let section: [Section]
    private let isMake: Bool
    
    
    // MARK: - 라이프사이클
    init(isMake: Bool) {
        self.section = Array(Section.allCases)
        self.isMake = isMake
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int {
        return self.section.count
    }
    
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String {
        return self.section[section].getHeaderTitle
    }
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        let tableData = self.section[section].getCellTitle
        let count = tableData.count
        // MARK: - Fix
        // 코드 리팩토링이 필요할 듯.
        // 개수로 하는 건 나중을 고려하지 않는 코드
        return count < 3 ? 50 : 5
    }
    
    // MARK: - 섹션 당 데이터 개수
    func getNumOfCell(section: Int) -> Int {
        let tableData = self.section[section].getCellTitle
        return tableData.count
    }
    
    // MARK: - 테이블 데이터
    func getTableData(section: Int, 
                      index: Int)
    -> String {
        let tableData: [String] = self.section[section].getCellTitle
        return tableData[index]
    }
    
    // MARK: - 하단 버튼 타이틀
    var getBottomBtnTitle: String? {
        return self.section.first?.getBottomBtnTitle(isMake: isMake)
    }
    
    // MARK: - 네비게이션 타이틀
    var getNavTitle: String? {
        return self.section.first?.getNavTitle(isMake: isMake)
    }
    
    // MARK: - 플레이스 홀더 텍스트
    func getPlaceholderTitle(index: Int) -> String {
        return self.section.first?.getTextFieldPlaceholder(index: index) ?? ""
    }
}
