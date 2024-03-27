//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class EditScreenVM<T: EditScreenType & CaseIterable>: ProfileEditVMProtocol {
    
    // 각 섹션에 대응하는 셀 타입들을 저장하는 딕셔너리
    private var dataProviders: [DataProvider]? = []
    // typealias EditCellDataCell = (type: EditCellType, detail: String?)
    private var cellDataDictionary: [Int: [EditCellDataCell]] = [:]
    
    
    
    
    
    // API 통신을 담당하는 프로토콜 객체
    private let api: EditScreenAPIType
    
    private let allCases: [T]
    
    // MARK: - 현재 선택된 셀
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 튜플
    private var selectedIndexTuple: (type: EditCellType, indexPath: IndexPath)?
    
    
    
    

    
    
    // 객체 생성 또는 편집 화면인지 구분하는 플래그
    private let isMake: Bool
    
    // 사용자에 의해 변경된 데이터를 저장하는 딕셔너리
    private var changedData: [String: Any?] = [:]
    
    
    
    // MARK: - 클로저
    // 방 데이터와 사용자 데이터를 업데이트할 때 사용할 클로저
    var roomDataClosure: ((Rooms) -> Void)?
    var userDataClosure: ((User) -> Void)?
    // 에러 발생 시 처리할 클로저
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(api: EditScreenAPIType, isMake: Bool) {
        self.api = api
        self.isMake = isMake
        self.allCases = Array(T.allCases)
        
        // 수정 -> 데이터 가져오기 ->> 셀 타입 초기화
        if !isMake {
            self.initializeCellTypes()
            print("initializeCellTypes ---")
        }
        else {
            self.setupDataProviders(withData: nil, decoration: nil)
        }
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    
    
    
    
    
    
    
    func setupDataProviders(
        withData data: ProviderModel?,
        decoration: Decoration?)
    {
        self.dataProviders = self.allCases
            .first?
            .createProviders(
                withData: data,
                decoration: decoration)
        // 여기서 self.decoration은 현재 VM이 가지고 있는 Decoration 데이터를 의미함
        self.updateCellData() // 필요한 경우 cell data 업데이트
    }
    
    
    private func updateCellData() {
        self.allCases.forEach { screenType in
            let cellData = screenType
                .getAllOfCellType
                .compactMap { cellType -> EditCellDataCell? in
                    
                    guard let provider = self.dataProviders?.first(where: { $0.canProvideData(for: cellType) }) else {
                        return (type: cellType, detail: nil)
                    }
                    
                    if let detailData = provider.provideData(for: cellType) {
                        return (type: cellType, detail: detailData)
                    }
                    
                    return (type: cellType, detail: nil)
                }
            self.cellDataDictionary[screenType.sectionIndex] = cellData
        }
    }
}




    
    
    
    
    
    
// MARK: - CellForRowAt
    
extension EditScreenVM {
    
    // MARK: - 셀 타입 반환
    // 특정 인덱스 패스에 해당하는 셀 타입을 반환하는 메소드
    func cellTypes(indexPath: IndexPath) -> EditCellType? {
        return self.cellDataDictionary[indexPath.section]?[indexPath.row].type
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
        self.changedData[type.databaseString] = data
    }
    
    // MARK: - 선택된 셀 및 인덱스 저장
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 메소드
    func saveCurrentIndexAndType(indexPath: IndexPath) -> EditCellType? {
        guard let type = self.cellTypes(indexPath: indexPath) else {
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
    func validation() async throws {
        guard let type = self.allCases.first else {
            throw ErrorEnum.unknownError // 첫 번째 케이스가 없는 경우, 알 수 없는 에러를 발생시킴
        }
        
        // 타입에 따라 유효성 검사 및 데이터 생성 함수를 호출
        try await self.validateType(type: type)
    }
    
    // MARK: - 타입 검사
    // 실제 유효성 검사 및 데이터 생성 로직을 포함하는 함수
    // 각 타입에 맞는 유효성 검사를 수행하고, 성공적이면 데이터 생성 함수를 호출
    private func validateType(type: any EditScreenType) async throws {
//        
//        switch type {
//        case is RoomEditEnum:
//            // 방(Room) 관련 데이터의 유효성 검사를 수행
//            guard self.roomValidation(type: RoomEditCellType.self) else { throw ErrorEnum.unknownError }
//            // 유효성 검사를 통과한 경우, 방을 생성하는 함수를 호출
//            let room = try await createData()
//            // 생성된 방 데이터를 클로저를 통해 전달
//            self.roomDataClosure?(room)
//            break
//            
//            
//        case is ProfileEditEnum:
//            // 사용자(User) 프로필 관련 데이터의 유효성 검사를 수행
//            guard self.roomValidation(type: ProfileEditCellType.self) else { throw ErrorEnum.unknownError }
//            // 유효성 검사를 통과한 경우, 사용자를 생성하는 함수를 호출
//            let user = try await createUser()
//            // 생성된 사용자 데이터를 클로저를 통해 전달
//            self.userDataClosure?(user)
//            break
//            
//            
//        default:
//            // 예상치 못한 타입의 경우, 알 수 없는 에러를 발생
//            throw ErrorEnum.unknownError
//        }
    }
    
    
    // MARK: - 타입별 유효성 검사
    // 각 타입별로 유효성 검사를 수행하는 함수
    // 모든 셀 타입에 대한 데이터가 변경된 데이터 딕셔너리에 존재하는지 검사
    private func roomValidation<Q: EditCellType & CaseIterable>(type: Q.Type) -> Bool {
        return Q.allCases.allSatisfy { self.changedData.keys.contains($0.databaseString) }
    }
    
    
    
    
    
    private func validateType222(type: any EditScreenType) async throws {
       
        do {
            guard self.roomValidation22() else { throw ErrorEnum.unknownError }
            try await self.createData()
            
            
        } catch {
            throw ErrorEnum.unknownError
        }
    }
    private func roomValidation22() -> Bool {
//        return self.allCases.first?.getAllOfCellType.first?.allSatisfy { self.changedData.keys.contains($0.databaseString) }
        
        return false
        
    }
    
    
}










// MARK: - API

extension EditScreenVM {
    
    // MARK: - 데이터 생성
    // 방(Room) / 유저(User) 생성을 위한 비동기 함수
    // 변경된 데이터를 바탕으로 API를 호출하여 방을 생성
    private func createData() async throws {
        let dict = self.changedData.compactMapValues { $0 }
        try await self.api.createData(dict: dict)
    }
}










// MARK: - 나중에 없앨 코드
extension EditScreenVM {
    private func initializeCellTypes() {
        let user: User = User(dictionary: [
            DatabaseConstants.personal_ID : "personal_ID",
            DatabaseConstants.user_name:  "user_name",
            DatabaseConstants.user_image : "user_image"
        ])
        
        let rooms: Rooms = Rooms(
            roomID: "roomID",
            versionID: "versionID",
            dictionary: [
                DatabaseConstants.room_name: "room_name",
                DatabaseConstants.room_image: "room_image"
            ])
        
        let decoration: Decoration = Decoration(
            blur: true,
            profileImage: "profileImage",
            backgroundImage: "backgroundImage",
            backgroundColor: "backgroundColor",
            pointColor: "pointColor",
            titleColor: "titleColor")
        
        self.setupDataProviders(withData: user, decoration: decoration)
    }
}
