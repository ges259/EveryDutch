//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class EditScreenVM: ProfileEditVMProtocol {
    
    private let sections: [EditScreenType]
    private var cellTypesDictionary: [Int: [EditCellType]] = [:]
    
    private let isMake: Bool
    
    
    
    
    // MARK: - 라이프사이클
    init<T: EditScreenType & CaseIterable>(
        isMake: Bool,
        editScreenType: T.Type)
    {
        self.isMake = isMake
        self.sections = Array(editScreenType.allCases)
        self.initializeCellTypes()
        
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    
    
// MARK: - 타입
    
    
    
    // MARK: - 타입 설정
    private func initializeCellTypes() {
        self.sections.forEach { [weak self] section in
            // 여기서는 section의 타입이 EditScreenType 프로토콜을 채택하는 enum이며,
            // 각 enum은 Int 타입의 rawValue를 가진다고 가정합니다.
            let sectionIndex = section.sectionIndex
            self?.cellTypesDictionary[sectionIndex] = section.getAllOfCellType
        }
    }
    
    
    // MARK: - 타입 반환
    func cellTypes(indexPath: IndexPath) -> EditCellType? {
        return self.cellTypesDictionary[indexPath.section]?[indexPath.row]
    }
    
    
    
    
    
// MARK: - 섹션 설정
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int {
        return self.sections.count
    }
    
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String {
        return self.sections[section].getHeaderTitle
    }
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        self.sections[section].footerViewHeight
    }
    
    
    
// MARK: - 셀
    
    
    
    // MARK: - 셀 개수
    func getNumOfCell(section: Int) -> Int {
        return self.cellTypesDictionary[section]?.count ?? 0
    }
    func getLastCell(indexPath: IndexPath) -> Bool {
        guard let count = self.cellTypesDictionary[indexPath.section]?.count else { return false }
        
        return (count - 1) == indexPath.row
        ? true
        : false
    }
    
    
    
    
    
// MARK: - isMake사용
// '생성'과 '수정'을 구분.
    // isMake == true ----> 생성
    // isMake == false ----> 수정
    
    // MARK: - 하단 버튼 타이틀
    var getBottomBtnTitle: String? {
        return self.sections[0].bottomBtnTitle(isMake: self.isMake)
    }
    
    // MARK: - 네비게이션 타이틀
    var getNavTitle: String? {
        return self.sections[0].getNavTitle(isMake: self.isMake)
    }
}
