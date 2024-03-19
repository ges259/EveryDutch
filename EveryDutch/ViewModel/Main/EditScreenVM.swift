//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//
// MARK: - Fix
// 하단 주석 친 코드와 같이 데이터가 변경되면, 저장. ( 어떤 식으로 저장해야 할지는 좀 더 생각해 봐야 할 듯)
import UIKit

final class EditScreenVM: ProfileEditVMProtocol {
    
    private let sections: [EditScreenType]
    private var cellTypesDictionary: [Int: [EditCellType]] = [:]
    
    private let isMake: Bool
    
    
    private var changedData: [String: Any?] = [:] {
        didSet {
            dump(self.changedData)
        }
    }
    
    private let api: EditScreenAPIType
    
    
    
    
    // MARK: - 라이프사이클
    init<T: EditScreenType & CaseIterable>(
        editScreenType: T.Type,
        editScreenApiType: EditScreenAPIType,
        isMake: Bool)
    {
        self.isMake = isMake
        self.api = editScreenApiType
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
    
    // MARK: - 인덱스 튜플
    private var currentIndexTuple: (type: EditCellType,
                                    indexPath: IndexPath)?
    
    // MARK: - 인덱스 반환
    func getCurrentCellType<T: EditCellType>(cellType: T.Type)
    -> (type: T, indexPath: IndexPath)? {
        
        guard let tuple = self.currentIndexTuple,
              let type = tuple.type as? T
        else { return nil }
        
        
        return (type: type, indexPath: tuple.indexPath)
    }
    
    
    
    
    
    
    
// MARK: - 데이터 저장
    
    
    
    // MARK: - 변경된 데이터 저장
    // 변경된 데이터 저장
    func saveChangedData<T: EditCellType>(type: T,
                                          data: Any?) {
        self.changedData[type.databaseString] = data
    }
    
    
    // MARK: - 인덱스 및 타입 저장
    func saveCurrentIndexAndType(indexPath: IndexPath) -> EditCellType? {
        guard let type = self.cellTypes(indexPath: indexPath) else {
            return nil
        }
        
        let indexPath = IndexPath(row: indexPath.row,
                                  section: indexPath.section)
        self.currentIndexTuple = (type: type,
                                  indexPath: indexPath)
        return type
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
    
    
    
    
    
// MARK: - 셀
    
    
    
    // MARK: - 셀 개수
    func getNumOfCell(section: Int) -> Int {
        return self.cellTypesDictionary[section]?.count ?? 0
    }
    
    // MARK: - 마지막 셀
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








// MARK: - 조건 검사

extension EditScreenVM {
    
    func validation(completion: @escaping (Result<Rooms?, ErrorEnum>) -> Void) {
        
        if let type = self.sections.first {
            if type is RoomEditEnum {
                if self.roomValidation(type: RoomEditCellType.self) {
                    print("validation 성공")
                    
                    self.createRoom(completion: completion)
                    
                    
                    
                } else {
                    completion(.failure(.readError))
                    print("validation 실패")
                }
            }
            
            else if type is ProfileEditEnum {
                if self.roomValidation(type: ProfileEditCellType.self) {
                    print("validation 성공")
                    self.createRoom(completion: completion)
                    
                } else {
                    completion(.failure(.readError))
                    print("validation 실패")
                }
            }
        }
    }
    
    
    private func roomValidation<T: EditCellType & CaseIterable>(
        type: T.Type) -> Bool
    {
        // type의 allCases를 통해 순환
        for type in T.allCases {
            // 특정 타입에 대한 데이터가 존재하지 않는 경우, 즉시 false 반환
            if !self.changedData.keys.contains(type.databaseString) {
                return false
            }
        }
        // 모든 타입에 대한 데이터가 존재하는 경우, true 반환
        return true
    }
    
    
    
    
    // MARK: - 유저 검색 또는 프로필 생성을 위한 유효성 검사
    func validation2() async throws -> Rooms? {
        guard let type = self.sections.first else {
            throw ErrorEnum.readError
        }
        
        // 유효성 검사를 수행하는 메서드 추출
        let isValid = await validateType(type: type)
        
        if !isValid {
            print("validation 실패")
            throw ErrorEnum.readError
        }
        
        print("validation 성공")
        // 유효성 검사에 성공하면 방을 생성
        return try await createRoom2()
    }
    
    // Type에 따른 유효성 검사 로직을 별도의 메서드로 분리
    private func validateType(type: EditScreenType) async -> Bool {
        if type is RoomEditEnum {
            return self.roomValidation(type: RoomEditCellType.self)
            
            
        } else if type is ProfileEditEnum {
            return self.roomValidation(type: ProfileEditCellType.self)
            
        }
        return false
    }

    
    // createRoom 함수가 async를 사용한다고 가정할 때
    private func createRoom2() async throws -> Rooms? {
        // 여기에 방 생성 관련 API 호출 로직 구현
        throw ErrorEnum.loginError
    }
    
    
    
    
}










// MARK: - API
extension EditScreenVM {
    private func createRoom(completion: @escaping (Result<Rooms?, ErrorEnum>) -> Void) {
        let dict = self.changedData.compactMapValues { $0 }
        
        self.api.createData(dict: dict, completion: completion)
    }
    
    private func createUser(completion: @escaping (Result<Rooms?, ErrorEnum>) -> Void) {
        
    }
}
