//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


final class EditScreenVM: ProfileEditVMProtocol {
    /**
     제네릭 T의 모든 타입
     - roomData / userData
     - cardDecoration
     */
    private let _allCases: [EditScreenType]
    /// API 통신을 담당하는 프로토콜 객체
    private var _api: EditScreenAPIType?
    // typealias EditCellTypeTuple = (type: EditCellType, detail: String?)
    private var _cellDataDictionary: [Int: [EditCellTypeTuple]] = [:]
    /// 현재 선택된 셀 타입과 인덱스 패스를 저장하는 튜플
    private var _selectedIndexTuple: (type: EditCellType, indexPath: IndexPath)?
    /// 생성이 아닌 '수정'인 경우, 이전 화면에서 가져온 데이터
    private var _dataRequiredWhenInEidtMode: String?
    
    
    
    // 플래그
    /// 객체 생성 또는 편집 화면인지 구분하는 플래그
    private var _isMake: Bool {
        return self._dataRequiredWhenInEidtMode == nil
    }
    /// [이미지 / 색상] 피커 상태를 저장하는 플래그
    private var _pickerStates: [EditScreenPicker: Bool] = [:]
    
    
    
    // 사용자에 의해 변경된 데이터를 저장하는 딕셔너리, DB에 저장할 예정
    /// [roomData / userData]의 텍스트 데이터를 저장하는 딕셔너리
    private var _textData: [String: Any?] = [:]
    /// cardDecoration의 다양한 타입의 데이터를 저장하는 딕셔너리
    private var _decorationData: [String: Any?] = [:]
    
    private var originalData: (data: EditProviderModel?, deco: Decoration?)?
    
    
    // 클로저
    // 방 데이터와 사용자 데이터를 업데이트할 때 사용할 클로저
    /// [화면에 처음 들어섰을 때, 테이블뷰의 데이터를 추가]
    var updateDataClosure: (() -> Void)?
    var successDataClosure: (() -> Void)?
    var decorationDataClosure: ((Decoration?) -> Void)?
    /// 에러 발생 시 처리할 클로저
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
    
    

    
    
    // MARK: - 라이프사이클
    init<T: EditScreenType & CaseIterable>(
        screenType: T.Type,
        dataRequiredWhenInEidtMode: String? = nil)
    {
        self._allCases = Array(T.allCases)
        self._dataRequiredWhenInEidtMode = dataRequiredWhenInEidtMode
        self._api = self._allCases.first?.apiType
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
        let datas = self._allCases.first?.createProviders(
            withData: data,
            decoration: decoration)
        
        guard let datas = datas else { return }
        
        self._cellDataDictionary = datas
        
        // 오리지널 데이터를 저장
        self.originalData = (data: data, deco: decoration)
        
        // 테이블뷰 리로드를 통해 [테이블 업데이트]
        self.updateDataClosure?()
    }
    /// '프로필 수정 화면'한정, 데이터를 가져오는 메서드
    func initializeCellTypes() {
        guard !self._isMake else { return }
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










// MARK: - 데이터 반환
extension EditScreenVM {
    // 화면 데이터
    /// 하단 버튼 타이틀 - 화면 하단에 표시될 버튼의 제목을 반환하는 변수
    /// T 타입(섹션 타입)의 첫 번째 케이스를 기준으로, isMake 변수의 값(true 또는 false)에 따라 해당하는 제목을 반환 이는 '생성' 또는 '수정' 화면에 따라 다른 텍스트를 표시할 때 사용
    var getBottomBtnTitle: String? {
        return self._allCases.first?.bottomBtnTitle(isMake: self._isMake)
    }
    // 화면 데이터
    /// 네비게이션 바에 표시될 제목을 반환하는 변수
    /// 이 역시 T 타입의 첫 번째 케이스를 기준으로, isMake 변수에 따라 적절한 제목을 반환
    /// '생성' 또는 '수정' 화면에 맞는 네비게이션 바 제목을 결정하는 데 사용 됨
    var getNavTitle: String? {
        return self._allCases.first?.getNavTitle(isMake: self._isMake)
    }
    
    
    // (셀 타입, 인덱스패스) 튜플
    /// 현재 선택된 셀의 셀 타입과 인덱스 패스를 반환하는 제네릭 메소드
    private func getCurrentCellType<F: EditCellType>() -> (type: F, indexPath: IndexPath)? {
        guard let tuple = self._selectedIndexTuple, 
                let type = tuple.type as? F
        else {
            return nil
        }
        return (type, tuple.indexPath)
    }
    
    /// 데코 셀 타입 및 인덱스패스 반환
    func getDecorationCellTypeTuple() -> (type: DecorationCellType, indexPath: IndexPath)? {
        return self.getCurrentCellType()
    }
    
    /// 현재 선택된 셀의 셀 타입 반환
    func getCurrentType() -> EditCellType? {
        return self._selectedIndexTuple?.type
    }
}





    
    



// MARK: - [테이블 데이터]
extension EditScreenVM {
    // 총 섹션의 개수를 반환하는 계산 프로퍼티
    var getNumOfSection: Int {
        return self._allCases.count
    }
    
    // 특정 섹션의 셀 개수를 반환하는 메소드
    func getNumOfCell(section: Int) -> Int {
        return self._cellDataDictionary[section]?.count ?? 0
    }
    
    // 특정 섹션의 헤더 타이틀을 반환하는 메소드
    func getHeaderTitle(section: Int) -> String {
        guard section >= 0 && section < self._allCases.count else {
            return "Invalid Section"
        }
        return self._allCases[section].getHeaderTitle
    }
    
    // 특정 인덱스 패스에 해당하는 셀 타입을 반환하는 메소드
    func getCellTuple(indexPath: IndexPath) -> EditCellTypeTuple? {
        return self._cellDataDictionary[indexPath.section]?[indexPath.row]
    }
    
    // 특정 섹션의 마지막 셀인지 여부를 반환하는 함수
    // indexPath로 주어진 위치가 해당 섹션의 마지막 셀 위치와 일치할 경우 true를 반환
    func getLastCell(indexPath: IndexPath) -> Bool {
        guard let count = self._cellDataDictionary[indexPath.section]?.count else { return false
        }
        return (count - 1) == indexPath.row
    }
}
    
 



    
    


// MARK: - 바뀐 데이터 저장
extension EditScreenVM {
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 메소드
    func saveCurrentIndex(indexPath: IndexPath) {
        guard let type = self.getCellTuple(indexPath: indexPath)?.type else {
            // MARK: - Fix
            // 에러 처리
            return
        }
        self._selectedIndexTuple = (type: type, indexPath: indexPath)
    }
    
    // 변경된 텍스트 데이터를 textData에 저장하는 메소드
    func saveChangedTextData(data: Any?) {
        guard let type = self._selectedIndexTuple?.type else { return }
        type.saveTextData(data: data, to: &self._textData)
    }

    func saveChangedDecorationData(data: Any?) {
        guard let type = self._selectedIndexTuple?.type else { return }
        type.saveDecorationData(data: data, to: &self._decorationData)
    }
    
    /// 텍스트 저장
    private func updateText(databaseString: String, text: Any?) {
        // 옵셔널바인딩 실패, 비어있는 상태라면, 지우기
        if let text = text as? String, text == "" {
            self._textData.removeValue(forKey: databaseString)
        } else {
            self._textData[databaseString] = text
        }
    }
    
    /// 피커 상태 저장
    func savePickerState(picker: EditScreenPicker, isOpen: Bool) {
        self._pickerStates[picker] = isOpen
    }
}










// MARK: - 데이터 가져오기
extension EditScreenVM {
    /// 데이터 가져오기
    private func fetchDatas() async throws {
        guard let dataID = self._dataRequiredWhenInEidtMode else { return }
        
        let data = try await self._api?.fetchData(dataRequiredWhenInEidtMode: dataID)
        let decoration = try await self._api?.fetchDecoration(dataRequiredWhenInEditMode: dataID)
        DispatchQueue.main.async {
            self.setupDataProviders(withData: data, decoration: decoration)
            // CardImgView와 테이블뷰의 decoration 섹션을 업데이트
            self.decorationDataClosure?(decoration)
        }
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
                print(#function)
                dump(self._textData)
                guard self.roomValidation() else { return }
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
        let dict = self._allCases.first?.validation(data: self._textData)
        
        // 오류 처리 (databaseString)
        if let dict = dict, !dict.isEmpty {
            self.errorClosure?(.validationError(dict))
            return false
        }
        return true
    }

    /// 모든 유효성 검사 및 데이터 처리 함수
    private func ApiOperation() async throws {
        // 개인_ID(Personal_ID) 유효성 검사 (ProfileEditEnum 한정)
        try await self.validationPersonalID()
        
        // 데이터 생성 또는 업데이트
        let refIdString: String = self._isMake
        ? try await self.createDataCellData()
        : try await self.updateDataCellData()
        
        // 이미지 저장 및 URL 병합
        try await self.saveImagesAndDecorationData()
        // 색상 데이터 변환
        self.updateColorDataToHex()
        // 데코 데이터 업데이트
        try await self._api?.updateDecoration(
            at: refIdString,
            with: self._decorationData)
    }
    private func validationPersonalID() async throws {
        guard let firstCase = self._allCases.first else { return }
        // '수정' 화면이라면
        if !self._isMake {
            // 개인 ID 중복 확인
            try await firstCase.validatePersonalID(
                api: self._api,
                textData: self._textData)
        }
    }
    
    // MARK: - Update
    private func updateDataCellData() async throws -> String {
        // 데이터 업데이트
        guard let refID = self._dataRequiredWhenInEidtMode else {
            throw ErrorEnum.readError
        }
        let dataDict = self._textData.compactMapValues { $0 }
        try await self._api?.updateData(IdRef: refID, dict: dataDict)
        
        return refID
    }
    
    // MARK: - Create
    // 데이터 셀 데이터를 생성하는 함수
    private func createDataCellData() async throws -> String {
        let dataDict = self._textData.compactMapValues { $0 }
        return try await self._api?.createData(dict: dataDict) ?? ""
    }
    
    // MARK: - 데코레이션
    // 이미지
    /// 이미지를 저장하고 데코 데이터를 저장하는 함수
    private func saveImagesAndDecorationData() async throws {
        // 데코 데이터에서 이미지를 추출
        let imageDict = self._decorationData.compactMapValues { $0 as? UIImage }
        
        // UIImage가 없다면 return
        guard !imageDict.isEmpty else { return }
        
        // 이미지를 업로드 후, url을 가져옴
        let urlDict = try await self._api?.uploadDecortaionImage(data: imageDict) ?? [:]
        // URL 데이터를 데코 데이터에 병합
        self._decorationData.merge(urlDict) { _, new in new }
    }
    
    // 색상
    /// 색상 데이터를 hex 값으로 변환하는 함수
    private func updateColorDataToHex() {
        self._decorationData = self._decorationData.mapValues { value in
            (value as? UIColor)?.toHexString() ?? value
        }
    }
}
