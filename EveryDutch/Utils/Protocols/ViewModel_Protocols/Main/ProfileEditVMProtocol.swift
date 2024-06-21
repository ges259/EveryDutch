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
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    var decorationDataClosure: ((Decoration?) -> Void)? { get set }
    
    // MARK: - 하단 버튼 타이틀
    var getBottomBtnTitle: String? { get }
    
    // MARK: - 네비게이션 타이틀
    var getNavTitle: String? { get }
    
    func saveCurrentIndex(indexPath: IndexPath)
    func getCurrentType() -> EditCellType?
    
    func initializeCellTypes()
//    var imagePickerIsOpen: Bool { get set }
    
    
    func savePickerState(picker: EditScreenPicker, isOpen: Bool)
    
    
//    func saveChangedData<T: EditCellType>(type: T,
//                         data: Any?)
    func saveChangedData(data: Any?)
    
    
//    func getCurrentCellType<T: EditCellType>(
//        cellType: T.Type)
//    -> (type: T,
//        indexPath: IndexPath)?
    
    
//    func geteImageCellTypeTuple() -> (type: ImageCellType, indexPath: IndexPath)?
    
    func getDecorationCellTypeTuple() -> (type: DecorationCellType, indexPath: IndexPath)?
    

    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int { get }
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String
    
    
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int
    
    // MARK: - 셀에 사용할 타입 반환
    func getCellTuple(indexPath: IndexPath) -> EditCellTypeTuple?
    
    // MARK: - 마지막 셀
    func getLastCell(indexPath: IndexPath) -> Bool
    
    
    
    
    
    // MARK: - 조건
    func validation()
}
