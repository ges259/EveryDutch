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
    // typealias EditCellTypeTuple = (type: EditCellType, detail: String?)
    private var cellDataDictionary: [Int: [EditCellTypeTuple]] = [:]
    
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
    private var isMake: Bool = false
    
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
    
    
    
    
    
    
    /*
     제네릭 T의 모든 타입
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
        // 생성 (비어있다면)
        if dataRequiredWhenInEidtMode == nil {
            self.isMake = true
        // 업데이트 (존재한다면)
        } else {
            self.dataRequiredWhenInEidtMode = dataRequiredWhenInEidtMode
        }
        
        self.allCases = Array(T.allCases)
        
        self.api = self.allCases.first?.apiType
        
        self.setupDataProviders()
    }
    deinit { print("\(#function)-----\(self)") }
}
    
    
    
// MARK: - 초기 설정
extension EditScreenVM {
    /// 셀을 만드는 메서드
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
    /// '프로필 수정 화면'한정, 데이터를 가져오는 메서드
    func initializeCellTypes() {
        guard !self.isMake else { return }
        print(#function)
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










// MARK: - 화면 데이터
extension EditScreenVM {
    /// 하단 버튼 타이틀 - 화면 하단에 표시될 버튼의 제목을 반환하는 변수
    /// T 타입(섹션 타입)의 첫 번째 케이스를 기준으로, isMake 변수의 값(true 또는 false)에 따라 해당하는 제목을 반환 이는 '생성' 또는 '수정' 화면에 따라 다른 텍스트를 표시할 때 사용
    var getBottomBtnTitle: String? {
        return self.allCases.first?.bottomBtnTitle(isMake: self.isMake)
    }
    
    /// 네비게이션 바에 표시될 제목을 반환하는 변수
    /// 이 역시 T 타입의 첫 번째 케이스를 기준으로, isMake 변수에 따라 적절한 제목을 반환
    /// '생성' 또는 '수정' 화면에 맞는 네비게이션 바 제목을 결정하는 데 사용 됨
    var getNavTitle: String? {
        return self.allCases.first?.getNavTitle(isMake: self.isMake)
    }
}










// MARK: - 튜플 반환
extension EditScreenVM {
    // 현재 선택된 셀 타입과 인덱스 패스를 반환하는 제네릭 메소드
    private func getCurrentCellType<F: EditCellType>(
        cellType: F.Type
    ) -> (type: F, indexPath: IndexPath)? {
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
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 메소드
    func saveCurrentIndex(indexPath: IndexPath) {
        guard let type = self.cellTypes(indexPath: indexPath)?.type else {
            // MARK: - Fix
            // 에러 처리
            return
        }
        self.selectedIndexTuple = (type: type, indexPath: indexPath)
    }
    
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
    
    /// 텍스트 저장
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
    // 총 섹션의 개수를 반환하는 계산 프로퍼티
    var getNumOfSection: Int {
        return self.allCases.count
    }
    
    // 특정 섹션의 셀 개수를 반환하는 메소드
    func getNumOfCell(section: Int) -> Int {
        return self.cellDataDictionary[section]?.count ?? 0
    }
    
    // 특정 섹션의 헤더 타이틀을 반환하는 메소드
    func getHeaderTitle(section: Int) -> String {
        guard section >= 0 && section < self.allCases.count else {
            return "Invalid Section"
        }
        return self.allCases[section].getHeaderTitle
    }
    
    // 특정 인덱스 패스에 해당하는 셀 타입을 반환하는 메소드
    func cellTypes(indexPath: IndexPath) -> EditCellTypeTuple? {
        return self.cellDataDictionary[indexPath.section]?[indexPath.row]
    }
    
    // 특정 섹션의 마지막 셀인지 여부를 반환하는 함수
    // indexPath로 주어진 위치가 해당 섹션의 마지막 셀 위치와 일치할 경우 true를 반환
    func getLastCell(indexPath: IndexPath) -> Bool {
        guard let count = self.cellDataDictionary[indexPath.section]?.count else { return false
        }
        return (count - 1) == indexPath.row
    }
}
    
 



    
    



// MARK: - 유효성 검사
extension EditScreenVM {
    // 비동기적으로 유효성 검사를 수행하는 함수
    // 현재 타입이 RoomEditEnum 또는 ProfileEditEnum인지 확인하고, 해당하는 동작을 실행
    @MainActor
    func validation() {
        Task {
            do {
                guard self.roomValidation() else { throw ErrorEnum.unknownError }
                try await self.ApiOperation()
                self.successDataClosure?()
                
            } catch let error as ErrorEnum {
                self.errorClosure?(error)
                
            } catch {
                self.errorClosure?(ErrorEnum.unknownError)
            }
        }
    }
    
    /// 유효성 검사
    private func roomValidation() -> Bool {
        let dict = self.allCases.first?.validation(data: self.textData)
        
        // 오류 처리 (databaseString)
        if let dict = dict, !dict.isEmpty {
            self.errorClosure?(.validationError(dict))
            return false
        }
        return true
    }
}










// MARK: - API
extension EditScreenVM {
    /// 모든 유효성 검사 및 데이터 처리 함수
    private func ApiOperation() async throws {
        // '수정' 화면이라면, 개인 ID 중복 확인
        if self.allCases.first is ProfileEditEnum {
            try await self.validatePersonalID()
        }
        
        // 데이터 생성 또는 업데이트
        let refIdString: String = self.isMake
        ? try await self.createDataCellData()
        : try await self.updateDataCellData()
        
        // 이미지 저장 및 URL 병합
        try await self.saveImagesAndDecorationData()
        // 색상 데이터 변환
        self.updateColorDataToHex()
        // 데코 데이터 업데이트
        try await self.api?.updateDecoration(at: refIdString, with: self.decorationData)
    }
    
    
    
    // MARK: - Update
    private func updateDataCellData() async throws -> String {
        // 데이터 업데이트
        guard let refID = self.dataRequiredWhenInEidtMode else {
            throw ErrorEnum.readError
        }
        let dataDict = self.textData.compactMapValues { $0 }
        try await self.api?.updateData(IdRef: refID, dict: dataDict)
        
        return refID
    }
    
    
    
    // MARK: - Create
    // 데이터 셀 데이터를 생성하는 함수
    private func createDataCellData() async throws -> String {
        let dataDict = self.textData.compactMapValues { $0 }
        return try await self.api?.createData(dict: dataDict) ?? ""
    }
    
    
    
    // MARK: - 공통
    // 중복 확인
    /// 개인 ID의 중복을 검사하는 코드
    private func validatePersonalID() async throws {
        // textData에서 personal_ID를 가져옴
        guard let personalID = self.textData[DatabaseConstants.personal_ID] as? String else { throw ErrorEnum.readError }
        // personal_ID가 중복되어있는지 확인
        let isExists = try await self.api?.validatePersonalID(personalID: personalID) ?? false
        // 이미 존재한다면(중복이라면), throw
        if isExists {
            throw ErrorEnum.validationError([DatabaseConstants.duplicatePersonalID] )
        }
    }
    
    
    // 이미지
    /// 이미지를 저장하고 데코 데이터를 저장하는 함수
    private func saveImagesAndDecorationData() async throws {
        // 데코 데이터에서 이미지를 추출
        let imageDict = self.decorationData.compactMapValues { $0 as? UIImage }
        // 이미지를 업로드 후, url을 가져옴
        let urlDict = try await self.api?.uploadImage(data: imageDict) ?? [:]
        // URL 데이터를 데코 데이터에 병합
        self.decorationData.merge(urlDict) { _, new in new }
    }
    
    // 색상
    /// 색상 데이터를 hex 값으로 변환하는 함수
    private func updateColorDataToHex() {
        self.decorationData = self.decorationData.mapValues { value in
            (value as? UIColor)?.toHexString() ?? value
        }
    }
    
    
    
    
    
    
    // MARK: - Fetch
    /// 데이터 가져오기
    private func fetchDatas() async throws {
        let data = try await self.api?.fetchData(dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
        let decoration = try await self.api?.fetchDecoration(dataRequiredWhenInEditMode: self.dataRequiredWhenInEidtMode)
        DispatchQueue.main.async {
            self.setupDataProviders(withData: data, decoration: decoration)
            self.decorationDataClosure?(decoration)
        }
    }
}
