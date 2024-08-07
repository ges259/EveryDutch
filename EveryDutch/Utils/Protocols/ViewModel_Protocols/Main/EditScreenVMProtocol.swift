//
//  ChatSettingProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

protocol EditScreenVMProtocol {
    var successDataClosure: (() -> Void)? { get set }
    var updateCellClosure: (() -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    
    /// 셀을 만드는 메서드
    func setupDataProviders() 
    // MARK: - 하단 버튼 타이틀
    var getBottomBtnTitle: String? { get }
    
    // MARK: - 네비게이션 타이틀
    var getNavTitle: String? { get }
    
    func saveCurrentIndex(indexPath: IndexPath)
    func getCurrentType() -> EditCellType?
    
    
    var getProviderModel: EditProviderModel? { get }
    var getDecoration: Decoration? { get }
    
    
    func savePickerState(picker: EditScreenPicker, isOpen: Bool)
    
    
//    func saveChangedData(data: Any?)
    
    func saveChangedTextData(data: Any?)
    func saveChangedDecorationData(data: Any?)
    
    
    
    
    func getDecorationCellTypeTuple() -> (type: DecorationCellType, indexPath: IndexPath)?
    

    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int { get }
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String
    
    
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int?
    
    // MARK: - 셀에 사용할 타입 반환
    func getCellTuple(indexPath: IndexPath) -> EditCellTypeTuple?
    
    // MARK: - 마지막 셀
    func getLastCell(indexPath: IndexPath) -> Bool
    
    
    
    
    
    // MARK: - 조건
    func validation()
}
