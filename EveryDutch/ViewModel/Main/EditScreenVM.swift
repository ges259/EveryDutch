//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class EditScreenVM<T: EditScreenType & CaseIterable>: ProfileEditVMProtocol {
    
    // 각 섹션에 대응하는 셀 타입들을 저장하는 딕셔너리
    private var cellTypesDictionary: [Int: [EditCellType]] = [:]
    
    // 객체 생성 또는 편집 화면인지 구분하는 플래그
    private let isMake: Bool
    
    // 사용자에 의해 변경된 데이터를 저장하는 딕셔너리
    private var changedData: [String: Any?] = [:]
    
    // API 통신을 담당하는 프로토콜 객체
    private let api: EditScreenAPIType
    
    private let allCases: [T]
    
    // MARK: - 현재 선택된 셀
    // 현재 선택된 셀 타입과 인덱스 패스를 저장하는 튜플
    private var currentIndexTuple: (type: EditCellType, indexPath: IndexPath)?
    
    
    
    
    
    
    
    
    
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
        self.initializeCellTypes() // 셀 타입 초기화
    }
    deinit { print("\(#function)-----\(self)") }
    
    // MARK: - 셀 타입 초기화
    // 각 섹션별로 해당하는 셀 타입들을 초기화하는 메소드
    private func initializeCellTypes() {
        self.allCases.forEach { section in
            let sectionIndex = section.sectionIndex
            self.cellTypesDictionary[sectionIndex] = section.getAllOfCellType
        }
    }
}
    
    
    
    
    
    
    
    
    
// MARK: - CellForRowAt
    
extension EditScreenVM {
    
    // MARK: - 셀 타입 반환
    // 특정 인덱스 패스에 해당하는 셀 타입을 반환하는 메소드
    func cellTypes(indexPath: IndexPath) -> EditCellType? {
        return self.cellTypesDictionary[indexPath.section]?[indexPath.row]
    }
    
    // MARK: - 마지막셀 검사
    // 특정 섹션의 마지막 셀인지 여부를 반환하는 함수
    // indexPath로 주어진 위치가 해당 섹션의 마지막 셀 위치와 일치할 경우 true를 반환
    func getLastCell(indexPath: IndexPath) -> Bool {
        return (self.cellTypesDictionary[indexPath.section]?.count ?? 0) - 1 == indexPath.row
    }
}

    
    







// MARK: - 바뀐 데이터 저장
    
extension EditScreenVM {
    
    // MARK: - 선택된 셀의 인덱스 반환
    // 현재 선택된 셀 타입과 인덱스 패스를 반환하는 제네릭 메소드
    func getCurrentCellType<F: EditCellType>(cellType: F.Type) -> (type: F, indexPath: IndexPath)? {
        guard let tuple = self.currentIndexTuple, let type = tuple.type as? F else {
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
        self.currentIndexTuple = (type: type, indexPath: indexPath)
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
        return self.cellTypesDictionary[section]?.count ?? 0
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
        return self.allCases.first?.bottomBtnTitle(isMake: isMake)
    }
    
    // MARK: - 네비게이션 타이틀
    // 네비게이션 바에 표시될 제목을 반환하는 변수
    // 이 역시 T 타입의 첫 번째 케이스를 기준으로, isMake 변수에 따라 적절한 제목을 반환
    // '생성' 또는 '수정' 화면에 맞는 네비게이션 바 제목을 결정하는 데 사용 됨
    var getNavTitle: String? {
        return self.allCases.first?.getNavTitle(isMake: isMake)
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
        try await validateType(type: type)
    }
    
    // MARK: - 타입 검사
    // 실제 유효성 검사 및 데이터 생성 로직을 포함하는 함수
    // 각 타입에 맞는 유효성 검사를 수행하고, 성공적이면 데이터 생성 함수를 호출
    private func validateType(type: EditScreenType) async throws {
        switch type {
        case is RoomEditEnum:
            // 방(Room) 관련 데이터의 유효성 검사를 수행
            guard self.roomValidation(type: RoomEditCellType.self) else { throw ErrorEnum.unknownError }
            
            // 유효성 검사를 통과한 경우, 방을 생성하는 함수를 호출
            let room = try await createRoom()
            
            // 생성된 방 데이터를 클로저를 통해 전달
            self.roomDataClosure?(room)
            
        case is ProfileEditEnum:
            // 사용자(User) 프로필 관련 데이터의 유효성 검사를 수행
            guard self.roomValidation(type: ProfileEditCellType.self) else { throw ErrorEnum.unknownError }
            
            // 유효성 검사를 통과한 경우, 사용자를 생성하는 함수를 호출
            let user = try await createUser()
            
            // 생성된 사용자 데이터를 클로저를 통해 전달
            self.userDataClosure?(user)
            
        default:
            // 예상치 못한 타입의 경우, 알 수 없는 에러를 발생
            throw ErrorEnum.unknownError
        }
    }
    
    // MARK: - 타입별 유효성 검사
    // 각 타입별로 유효성 검사를 수행하는 함수
    // 모든 셀 타입에 대한 데이터가 변경된 데이터 딕셔너리에 존재하는지 검사
    private func roomValidation<Q: EditCellType & CaseIterable>(type: Q.Type) -> Bool {
        return Q.allCases.allSatisfy { self.changedData.keys.contains($0.databaseString) }
    }
}










// MARK: - API

extension EditScreenVM {
    
    // MARK: - Room 생성
    // 방(Room) 생성을 위한 비동기 함수
    // 변경된 데이터를 바탕으로 API를 호출하여 방을 생성하고, 결과를 반환
    private func createRoom() async throws -> Rooms {
        guard let api = self.api as? RoomEditAPIType else {
            throw ErrorEnum.unknownError // 적절한 API 타입이 아닐 경우, 에러를 발생시킴
        }
        let dict = self.changedData.compactMapValues { $0 }
        return try await api.createData(dict: dict)
    }
    
    // MARK: - User 생성
    // 사용자(User) 생성을 위한 비동기 함수
    // 변경된 데이터를 바탕으로 API를 호출하여 사용자를 생성하고, 결과를 반환
    private func createUser() async throws -> User {
        guard let api = self.api as? ProfileEditAPIType else {
            throw ErrorEnum.unknownError // 적절한 API 타입이 아닐 경우, 에러를 발생시킴
        }
        let dict = self.changedData.compactMapValues { $0 }
        return try await api.createData(dict: dict)
    }
}



