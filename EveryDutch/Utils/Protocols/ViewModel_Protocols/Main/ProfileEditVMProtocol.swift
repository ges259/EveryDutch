//
//  ChatSettingProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol ProfileEditVMProtocol {
    var successDataClosure: (() -> Void)? { get set }
    var updateDataClosure: (() -> Void)? { get set }
    var makeDataClosure: ((EditProviderModel) -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    
    
    // MARK: - 하단 버튼 타이틀
    var getBottomBtnTitle: String? { get }
    
    // MARK: - 네비게이션 타이틀
    var getNavTitle: String? { get }
    
    func saveCurrentIndexAndType(indexPath: IndexPath) -> EditCellType?
    
    
    
    func saveChangedData<T: EditCellType>(type: T,
                         data: Any?)
    
    
    
    func getCurrentCellType<T: EditCellType>(
        cellType: T.Type)
    -> (type: T,
        indexPath: IndexPath)?
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int { get }
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String
    
    
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int
    
    // MARK: - 셀에 사용할 타입 반환
    func cellTypes(indexPath: IndexPath) -> EditCellDataCell?
    
    // MARK: - 마지막 셀
    func getLastCell(indexPath: IndexPath) -> Bool
    
    
    
    
    
    // MARK: - 조건
    func validation()
}
