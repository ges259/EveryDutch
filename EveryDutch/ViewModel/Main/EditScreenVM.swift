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
    
    

    
    
    // 객체 생성 또는 편집 화면인지 구분하는 플래그
    private let isMake: Bool
    
    // 사용자에 의해 변경된 데이터를 저장하는 딕셔너리
    private var changedData: [String: Any?] = [:]
    private var imageData: [String: Any?] = [:]
    private var decorationData: [String: Any?] = [:]
    
    
    
    
    // MARK: - 클로저
    // 방 데이터와 사용자 데이터를 업데이트할 때 사용할 클로저
    var updateDataClosure: (() -> Void)?
    var successDataClosure: (() -> Void)?
    var makeDataClosure: ((EditProviderModel) -> Void)?
    // 에러 발생 시 처리할 클로저
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
    
    
    
    
    // 제네릭 T의 모든 타입
    /*
     type
     - roomData / userData
     - imageData
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
            Task { await self.initializeCellTypes() }
        }
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    private func initializeCellTypes() async {
        // 수정 -> 데이터 가져오기 ->> 셀 타입 초기화
        do {
            try await self.fetchDatas()
        } catch let error as ErrorEnum {
            self.errorClosure?(error)
        } catch {
            self.errorClosure?(.unknownError)
        }
        print("initializeCellTypes ---")
    }
    
    
    
    
    
    
    func setupDataProviders(
        withData data: EditProviderModel? = nil,
        decoration: Decoration? = nil)
    {
        let dataProviders = self.allCases
            .first?
            .createProviders(
                withData: data,
                decoration: decoration)
        // 여기서 self.decoration은 현재 VM이 가지고 있는 Decoration 데이터를 의미함
        self.updateCellData(with: dataProviders) // 필요한 경우 cell data 업데이트
    }
    
    
    private func updateCellData(with dataProviders: [EditDataProvider]?) {
        self.allCases.forEach { screenType in
            let cellData = screenType
                .getAllOfCellType
                .compactMap { cellType -> EditCellDataCell? in
                    
                    guard let provider = dataProviders?.first(where: { $0.canProvideData(for: cellType) }) else {
                        return (type: cellType, detail: nil)
                    }
                    
                    if let detailData = provider.provideData(for: cellType) {
                        return (type: cellType, detail: detailData)
                    }
                    
                    return (type: cellType, detail: nil)
                }
            self.cellDataDictionary[screenType.sectionIndex] = cellData
            self.updateDataClosure?()
        }
    }
}




    
    
    
    
    
    
// MARK: - CellForRowAt
    
extension EditScreenVM {
    
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

    
    







// MARK: - 바뀐 데이터 저장
    
extension EditScreenVM {
    
    // MARK: - 선택된 셀의 인덱스 반환
    // 현재 선택된 셀 타입과 인덱스 패스를 반환하는 제네릭 메소드
    func getCurrentCellType<F: EditCellType>(cellType: F.Type) -> (type: F, indexPath: IndexPath)? {
        guard let tuple = self.selectedIndexTuple, let type = tuple.type as? F else {
            return nil
        }
        return (type, tuple.indexPath)
    }
    
    // MARK: - 변경된 데이터 저장
    // 변경된 데이터를 저장하는 메소드
    func saveChangedData<R: EditCellType>(type: R, data: Any?) {
        let databaseString = type.databaseString
        
        switch type {
        case is ImageCellType : 
            self.decorationData[databaseString] = data
            break
            
        case is DecorationCellType: 
            self.decorationData[databaseString] = data
            break
            
        default: 
            self.changedData[databaseString] = data
            break
        }
    }
    
    // MARK: - 선택된 셀 및 인덱스 저장
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 메소드
    func saveCurrentIndexAndType(indexPath: IndexPath) -> EditCellType? {
        guard let type = self.cellTypes(indexPath: indexPath)?.type else {
            return nil
        }
        self.selectedIndexTuple = (type: type, indexPath: indexPath)
        return type
    }
}
    
    
    
    
    
    
    



// MARK: - 테이블 데이터

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
}
    
 



    
    



// MARK: - 화면 데이터

extension EditScreenVM {
    
    // MARK: - 헤더 타이틀
    // 특정 섹션의 헤더 타이틀을 반환하는 메소드
    func getHeaderTitle(section: Int) -> String {
        guard section >= 0 && section < self.allCases.count else {
            return "Invalid Section"
        }
        return self.allCases[section].getHeaderTitle
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
        var missingFields: [String] = []
        
        for type in self.allCases {
            /*
             cellType
             - RoomEditCellType.allCases
             - ImageCellType.allCases
             - DecorationCellType.allCases
             */
            for cellType in type.getAllOfCellType {
                if let cellTypeEnyum = cellType as? ValidationType {
                    let missingForType = cellTypeEnyum.validation(dict: self.changedData)
                    missingFields.append(contentsOf: missingForType)
                    break
                }
            }
            // 첫 번째 type에서 누락된 필드가 발견되면 전체 검증 중단
            // 필요에 따라 이 부분을 조정
            if !missingFields.isEmpty { break }
        }
        // 빈칸           -> true
        // 오류값이 있다    -> false
        return missingFields.isEmpty
    }
}










// MARK: - API

extension EditScreenVM {
    
    // MARK: - 데이터 생성
    // 방(Room) / 유저(User) 생성을 위한 비동기 함수
    // 변경된 데이터를 바탕으로 API를 호출하여 방을 생성
    private func createData() async throws {
        let dict = self.changedData.compactMapValues { $0 }
        let data = try await self.api?.createData(dict: dict)
        try await self.api?.updateDecoration(
            at: data,
            with: self.decorationData)
    }
}










// MARK: - 나중에 없앨 코드
extension EditScreenVM {
    
    private func fetchDatas() async throws {
        let data = try await self.api?.fetchData(dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
        let decoration = try await self.api?.fetchDecoration(dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
        DispatchQueue.main.async {
            self.setupDataProviders(withData: data, decoration: decoration)
        }
    }
}
