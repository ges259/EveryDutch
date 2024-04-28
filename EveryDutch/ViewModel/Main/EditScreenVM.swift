//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

/*
 해야 할 일
 - 빈칸되면 ChangedData에서 삭제
 */

final class EditScreenVM: ProfileEditVMProtocol {
    // typealias EditCellDataCell = (type: EditCellType, detail: String?)
    private var cellDataDictionary: [Int: [EditCellDataCell]] = [:]
    
    // API 통신을 담당하는 프로토콜 객체
    private var api: EditScreenAPIType?
    
    
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 튜플
    private var selectedIndexTuple: (type: EditCellType, indexPath: IndexPath)?
    
    private var dataRequiredWhenInEidtMode: String?
    
    
    
    
    
    /// 피커 상태
    private var pickerStates: [EditScreenPicker: Bool] = [:]
    
    // MARK: - 피커 상태 저장
    func savePickerState(picker: EditScreenPicker, isOpen: Bool) {
        self.pickerStates[picker] = isOpen
    }
    
    
    // 객체 생성 또는 편집 화면인지 구분하는 플래그
    private let isMake: Bool
    
    // 사용자에 의해 변경된 데이터를 저장하는 딕셔너리, DB에 저장할 예정
    private var textData: [String: Any?] = [:]
    private var decorationData: [String: Any?] = [:]
    
    
    
    
    // MARK: - 클로저
    // 방 데이터와 사용자 데이터를 업데이트할 때 사용할 클로저
    var updateDataClosure: (() -> Void)?
    var successDataClosure: (() -> Void)?
    var makeDataClosure: ((EditProviderModel) -> Void)?
    var decorationDataClosure: ((Decoration?) -> Void)?
    // 에러 발생 시 처리할 클로저
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
//    private var currentData: (textData: EditProviderModel?, decoration: Decoration?)?
    
    
    
    // 제네릭 T의 모든 타입
    /*
     type
     - roomData / userData
     - cardDecoration
     */
    private let allCases: [EditScreenType]
    
    
    // MARK: - 라이프사이클
    init<T: EditScreenType & CaseIterable>(
        screenType: T.Type,
        dataRequiredWhenInEidtMode: String? = nil)
    {
        self.isMake = dataRequiredWhenInEidtMode == nil
        self.allCases = Array(T.allCases)
        
        self.api = self.allCases.first?.apiType
        
        self.setupDataProviders()
        
        if !self.isMake {
            self.dataRequiredWhenInEidtMode = dataRequiredWhenInEidtMode
            self.initializeCellTypes()
        }
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    // MARK: - 초기 설정
    private func initializeCellTypes() {
        Task {
            // 수정 -> 데이터 가져오기 ->> 셀 타입 초기화
            do {
                try await self.fetchDatas()
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
            } catch {
                self.errorClosure?(.unknownError)
            }
        }
    }
}










// MARK: - 튜플 반환
extension EditScreenVM {
    // 현재 선택된 셀 타입과 인덱스 패스를 반환하는 제네릭 메소드
    private func getCurrentCellType<F: EditCellType>(
        cellType: F.Type) -> (type: F, indexPath: IndexPath)?
    {
        guard let tuple = self.selectedIndexTuple, let type = tuple.type as? F else {
            return nil
        }
        return (type, tuple.indexPath)
    }
    
    // MARK: - 데코 셀
    func getDecorationCellTypeTuple() -> (type: DecorationCellType, indexPath: IndexPath)? {
        return self.getCurrentCellType(cellType: DecorationCellType.self)
    }
    
    // MARK: - 셀 반환
    func getCurrentType() -> EditCellType? {
        return self.selectedIndexTuple?.type
    }
}





    
    
    
    

// MARK: - 바뀐 데이터 저장
    
extension EditScreenVM {
    
    // MARK: - 선택된 셀 및 인덱스 저장
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 메소드
    func saveCurrentIndex(indexPath: IndexPath) {
        guard let type = self.cellTypes(indexPath: indexPath)?.type else {
            // MARK: - Fix
            // 에러 처리
            return
        }
        self.selectedIndexTuple = (type: type, indexPath: indexPath)
    }
    
    // MARK: - 변경된 데이터 저장
    // 변경된 데이터를 저장하는 메소드
    func saveChangedData(data: Any?) {
        // type가져오기
        guard let type = self.selectedIndexTuple?.type else { return }
        
        // 각 type에 저장된 데이터베이스 String 가져오기
        let databaseString = type.databaseString
        
        switch type {
        case is RoomEditCellType, is ProfileEditCellType:
            self.updateText(databaseString: databaseString, text: data)
            break
            
        case is DecorationCellType:
            self.decorationData[databaseString] = data
            break
            
        default: 
            print("Error --- \(self) --- \(#function)")
            self.errorClosure?(.changeEditDataError)
            break
        }
    }
    
    
    private func updateText(databaseString: String, text: Any?) {
        // 옵셔널바인딩 실패, 비어있는 상태라면, 지우기
        if let text = text as? String, text == "" {
            self.textData.removeValue(forKey: databaseString)
        } else {
            self.textData[databaseString] = text
        }
    }
}
    
    
    
    
    
    
    



// MARK: - [테이블 데이터]

extension EditScreenVM {
    
    // MARK: - 섹션의 개수
    // 총 섹션의 개수를 반환하는 계산 프로퍼티
    var getNumOfSection: Int {
        return self.allCases.count
    }
    
    // MARK: - 셀의 개수
    // 특정 섹션의 셀 개수를 반환하는 메소드
    func getNumOfCell(section: Int) -> Int {
        return self.cellDataDictionary[section]?.count ?? 0
    }
    
    // MARK: - 헤더 타이틀
    // 특정 섹션의 헤더 타이틀을 반환하는 메소드
    func getHeaderTitle(section: Int) -> String {
        guard section >= 0 && section < self.allCases.count else {
            return "Invalid Section"
        }
        return self.allCases[section].getHeaderTitle
    }
    
    // MARK: - 셀 타입 반환
    // 특정 인덱스 패스에 해당하는 셀 타입을 반환하는 메소드
    func cellTypes(indexPath: IndexPath) -> EditCellDataCell? {
        return self.cellDataDictionary[indexPath.section]?[indexPath.row]
    }
    
    // MARK: - 마지막셀 검사
    // 특정 섹션의 마지막 셀인지 여부를 반환하는 함수
    // indexPath로 주어진 위치가 해당 섹션의 마지막 셀 위치와 일치할 경우 true를 반환
    func getLastCell(indexPath: IndexPath) -> Bool {
        return (self.cellDataDictionary[indexPath.section]?.count ?? 0) - 1 == indexPath.row
    }
}
    
 



    
    



// MARK: - 셀 생성
extension EditScreenVM {
    private func setupDataProviders(
        withData data: EditProviderModel? = nil,
        decoration: Decoration? = nil)
    {
        let datas = self.allCases.first?.createProviders(
            withData: data,
            decoration: decoration)
        
        guard let datas = datas else { return }
        self.cellDataDictionary = datas
        
        // 테이블뷰 리로드를 통해 [테이블 업데이트]
        self.updateDataClosure?()
    }
        
    // MARK: - 하단 버튼 타이틀
    // 화면 하단에 표시될 버튼의 제목을 반환하는 변수
    // T 타입(섹션 타입)의 첫 번째 케이스를 기준으로, isMake 변수의 값(true 또는 false)에 따라 해당하는 제목을 반환 이는 '생성' 또는 '수정' 화면에 따라 다른 텍스트를 표시할 때 사용
    var getBottomBtnTitle: String? {
        return self.allCases.first?.bottomBtnTitle(
            isMake: self.isMake)
    }
    
    // MARK: - 네비게이션 타이틀
    // 네비게이션 바에 표시될 제목을 반환하는 변수
    // 이 역시 T 타입의 첫 번째 케이스를 기준으로, isMake 변수에 따라 적절한 제목을 반환
    // '생성' 또는 '수정' 화면에 맞는 네비게이션 바 제목을 결정하는 데 사용 됨
    var getNavTitle: String? {
        return self.allCases.first?.getNavTitle(
            isMake: self.isMake)
    }
}


    
    
    
    




// MARK: - 유효성 검사

extension EditScreenVM {
    
    // MARK: - 시작
    // 비동기적으로 유효성 검사를 수행하는 함수
    // 현재 타입이 RoomEditEnum 또는 ProfileEditEnum인지 확인하고, 해당하는 동작을 실행
    @MainActor
    func validation() {
        Task {
            do {
                guard self.roomValidation() else { throw ErrorEnum.unknownError }
                // MARK: - Fix
                // 나중에 주석 풀기
                try await self.createData()
                self.successDataClosure?()
                
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
                
            } catch {
                self.errorClosure?(ErrorEnum.unknownError)
            }
        }
    }
    
    // MARK: - 유효성 검사
    private func roomValidation() -> Bool {
        let dict = self.allCases.first?.validation(data: self.textData)
        // MARK: - Fix
        // 오류 처리 (databaseString)
        if let dict = dict, dict.isEmpty {
            self.errorClosure?(.validationError(dict))
            return false
        }
        return true
    }
}










// MARK: - API

extension EditScreenVM {
    
    // MARK: - 데이터 가져오기
    private func fetchDatas() async throws {
        let data = try await self.api?.fetchData(dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
        let decoration = try await self.api?.fetchDecoration(dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
        DispatchQueue.main.async {
            self.setupDataProviders(withData: data, decoration: decoration)
            self.decorationDataClosure?(decoration)
        }
    }
    
    // MARK: - 데이터 생성(업데이트)
    // 방(Room) / 유저(User) 생성을 위한 비동기 함수
    // 변경된 데이터를 바탕으로 API를 호출하여 방을 생성
    private func createData() async throws {
        // 방 또는 유저의 데이터 저장
        let dict = self.textData.compactMapValues { $0 }
        let ref = try await self.api?.createData(dict: dict)
        
        // 이미지 데이터 분리
        let imageDict = self.extractImagesFromDecorationData()
        // 이미지를 스토리지에 저장 후, url가져오기
        guard let urlDict = try await self.api?.uploadImage(data: imageDict) else {
            throw ErrorEnum.NoPersonalID
        }
        self.mergeDecorationData(with: urlDict)
        // 색상 데이터를 hex로 바꾸기
        self.updateColorDataToHex()
        // 데코 데이터 저장
        try await self.api?.updateDecoration(at: ref, with: self.decorationData)
    }
    
    /// decoationData에서 value값이 UIImage인 데이터를 추출하여 리턴
    private func extractImagesFromDecorationData() -> [String: UIImage] {
        return self.decorationData.reduce(into: [String: UIImage]()) { (result, element) in
            if let image = element.value as? UIImage {
                result[element.key] = image
            }
        }
    }
    /// value값이 String(url)인 딕셔너리를 decoration과 합침
    private func mergeDecorationData(with urlDict: [String: String]) {
        for (key, url) in urlDict {
            self.decorationData[key] = url  // 이미지 경로를 저장
        }
    }
    /// /// decoationData에서 value값이 UIColor인 데이터를 hex값으로 바꿈
    private func updateColorDataToHex() {
        for (key, value) in self.decorationData {
            if let color = value as? UIColor {
                self.decorationData[key] = color.toHexString()
            }
        }
    }
}
