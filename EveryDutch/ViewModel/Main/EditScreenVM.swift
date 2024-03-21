//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//
// MARK: - Fix
// 하단 주석 친 코드와 같이 데이터가 변경되면, 저장. ( 어떤 식으로 저장해야 할지는 좀 더 생각해 봐야 할 듯)
import UIKit

//final class EditScreenVM: ProfileEditVMProtocol {
//    
//    private let sections: [EditScreenType]
//    private var cellTypesDictionary: [Int: [EditCellType]] = [:]
//    
//    private let isMake: Bool
//    
//    
//    private var changedData: [String: Any?] = [:] {
//        didSet {
//            dump(self.changedData)
//        }
//    }
//    
//    private let api: EditScreenAPIType
//    
//    var createRoomClosure: ((Rooms) -> Void)?
//    var updateRoomClosure: ((Rooms) -> Void)?
//    
//    var createUserClosure: ((User) -> Void)?
//    var updateUserClosure: ((User) -> Void)?
//    
//    
//    
//    
//    // MARK: - 라이프사이클
//    init<T: EditScreenType & CaseIterable>(
//        editScreenType: T.Type,
//        editScreenApiType: EditScreenAPIType,
//        isMake: Bool)
//    {
//        self.isMake = isMake
//        self.api = editScreenApiType
//        self.sections = Array(editScreenType.allCases)
//        self.initializeCellTypes()
//    }
//    deinit {
//        print("\(#function)-----\(self)")
//    }
//    
//    
//    
//    
//    
//    
//    
//// MARK: - 타입
//    
//    
//    
//    // MARK: - 타입 설정
//    private func initializeCellTypes() {
//        self.sections.forEach { [weak self] section in
//            // 여기서는 section의 타입이 EditScreenType 프로토콜을 채택하는 enum이며,
//            // 각 enum은 Int 타입의 rawValue를 가진다고 가정합니다.
//            let sectionIndex = section.sectionIndex
//            self?.cellTypesDictionary[sectionIndex] = section.getAllOfCellType
//        }
//    }
//    
//    
//    // MARK: - 타입 반환
//    func cellTypes(indexPath: IndexPath) -> EditCellType? {
//        return self.cellTypesDictionary[indexPath.section]?[indexPath.row]
//    }
//    
//    // MARK: - 인덱스 튜플
//    private var currentIndexTuple: (type: EditCellType,
//                                    indexPath: IndexPath)?
//    
//    // MARK: - 인덱스 반환
//    func getCurrentCellType<T: EditCellType>(cellType: T.Type)
//    -> (type: T, indexPath: IndexPath)? {
//        
//        guard let tuple = self.currentIndexTuple,
//              let type = tuple.type as? T
//        else { return nil }
//        
//        
//        return (type: type, indexPath: tuple.indexPath)
//    }
//    
//    
//    
//    
//    
//    
//    
//// MARK: - 데이터 저장
//    
//    
//    
//    // MARK: - 변경된 데이터 저장
//    // 변경된 데이터 저장
//    func saveChangedData<T: EditCellType>(type: T,
//                                          data: Any?) {
//        self.changedData[type.databaseString] = data
//    }
//    
//    
//    // MARK: - 인덱스 및 타입 저장
//    func saveCurrentIndexAndType(indexPath: IndexPath) -> EditCellType? {
//        guard let type = self.cellTypes(indexPath: indexPath) else {
//            return nil
//        }
//        
//        let indexPath = IndexPath(row: indexPath.row,
//                                  section: indexPath.section)
//        self.currentIndexTuple = (type: type,
//                                  indexPath: indexPath)
//        return type
//    }
//    
//    
//    
//    
//    
//// MARK: - 섹션 설정
//    
//    
//    
//    // MARK: - 섹션의 개수
//    var getNumOfSection: Int {
//        return self.sections.count
//    }
//    
//    // MARK: - 헤더의 타이틀
//    func getHeaderTitle(section: Int) -> String {
//        return self.sections[section].getHeaderTitle
//    }
//    
//    
//    
//    
//    
//// MARK: - 셀
//    
//    
//    
//    // MARK: - 셀 개수
//    func getNumOfCell(section: Int) -> Int {
//        return self.cellTypesDictionary[section]?.count ?? 0
//    }
//    
//    // MARK: - 마지막 셀
//    func getLastCell(indexPath: IndexPath) -> Bool {
//        guard let count = self.cellTypesDictionary[indexPath.section]?.count else { return false }
//        
//        return (count - 1) == indexPath.row
//        ? true
//        : false
//    }
//    
//    
//    
//    
//    
//// MARK: - isMake사용
//// '생성'과 '수정'을 구분.
//    // isMake == true ----> 생성
//    // isMake == false ----> 수정
//    
//    // MARK: - 하단 버튼 타이틀
//    var getBottomBtnTitle: String? {
//        return self.sections[0].bottomBtnTitle(isMake: self.isMake)
//    }
//    
//    // MARK: - 네비게이션 타이틀
//    var getNavTitle: String? {
//        return self.sections[0].getNavTitle(isMake: self.isMake)
//    }
//}
//
//
//
//
//
//
//
//
//// MARK: - 조건 검사
//
//extension EditScreenVM {
//    
//    // MARK: - 유저 검색 또는 프로필 생성을 위한 유효성 검사
//    func validation() async throws {
//        guard let type = self.sections.first else {
//            throw ErrorEnum.readError
//        }
//        // 유효성 검사 및 에러 처리
//        try await validateType(type: type)
//        
//        return
//    }
//    
//    // Type에 따른 유효성 검사 로직을 별도의 메서드로 분리
//    private func validateType(type: EditScreenType) async throws {
//        switch type {
//        case is RoomEditEnum:
//            guard self.roomValidation(type: RoomEditCellType.self) 
//            else { throw ErrorEnum.readError }
//            // 유효성 검사에 성공하면 방을 생성
//            let room = try await createRoom()
//            self.createRoomClosure?(room)
//            
//        case is ProfileEditEnum:
//            guard self.roomValidation(type: ProfileEditCellType.self) 
//            else { throw ErrorEnum.readError }
//            
//            // 유효성 검사에 성공하면 유저 데이터를 생성
//            let user = try await createUser()
//            self.createUserClosure?(user)
//            
//            
//        default:
//            print("알 수 없는 타입")
//            throw ErrorEnum.readError
//        }
//        print("validation 성공")
//    }
//
//    private func roomValidation<T: EditCellType & CaseIterable>(
//        type: T.Type) -> Bool
//    {
//        // type의 allCases를 통해 순환
//        for type in T.allCases {
//            // 특정 타입에 대한 데이터가 존재하지 않는 경우, 즉시 false 반환
//            if !self.changedData.keys.contains(type.databaseString) {
//                return false
//            }
//        }
//        // 모든 타입에 대한 데이터가 존재하는 경우, true 반환
//        return true
//    }
//    
//
//}
//
//
//
//
//
//
//
//
//
//
//// MARK: - API
//extension EditScreenVM {
//    // createRoom 함수가 async를 사용한다고 가정할 때
//    func createRoom() async throws -> Rooms {
//        
//        guard let api = self.api as? RoomEditAPIType else {
//            throw ErrorEnum.readError
//        }
//        
//        let dict = self.changedData.compactMapValues { $0 }
//        
//        // 방 생성 관련 API 호출 로직 구현
//        // 여기서는 예제로 에러를 throw하고 있지만, 실제로는 API 호출 결과에 따라 Rooms 객체를 반환하거나 에러를 throw해야 합니다.
//        let rooms = try await api.createData(dict: dict)
//        
//        return rooms
//    }
//    
//    func createUser() async throws -> User {
//        guard let api = self.api as? ProfileEditAPIType else {
//            throw ErrorEnum.readError
//        }
//
//        let dict = self.changedData.compactMapValues { $0 }
//        
//        // 유저 생성 관련 API 호출 로직 구현
//        let user = try await api.createData(dict: dict)
//        return user
//    }
//    
//}
//
//
//
//
//
//
//
//










































final class EditScreenVM<T: EditScreenType & CaseIterable>: ProfileEditVMProtocol {
    private var cellTypesDictionary: [Int: [EditCellType]] = [:]
    private let isMake: Bool
    private var changedData: [String: Any?] = [:] {
        didSet {
            dump(changedData)
        }
    }
    private let api: EditScreenAPIType
    
    var roomDataClosure: ((Rooms) -> Void)?
    var userDataClosure: ((User) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    init(api: EditScreenAPIType, isMake: Bool) {
        self.api = api
        self.isMake = isMake
        initializeCellTypes()
    }
    
    deinit {
        print("\(#function)-----\(self)")
    }
    
    private func initializeCellTypes() {
        T.allCases.forEach { section in
            let sectionIndex = section.sectionIndex
            cellTypesDictionary[sectionIndex] = section.getAllOfCellType
        }
    }
    
    func cellTypes(indexPath: IndexPath) -> EditCellType? {
        return cellTypesDictionary[indexPath.section]?[indexPath.row]
    }
    
    private var currentIndexTuple: (type: EditCellType, indexPath: IndexPath)?
    
    func getCurrentCellType<F: EditCellType>(cellType: F.Type) -> (type: F, indexPath: IndexPath)? {
        guard let tuple = currentIndexTuple, let type = tuple.type as? F else {
            return nil
        }
        return (type, tuple.indexPath)
    }
    
    func saveChangedData<R: EditCellType>(type: R, data: Any?) {
        changedData[type.databaseString] = data
    }
    
    func saveCurrentIndexAndType(indexPath: IndexPath) -> EditCellType? {
        guard let type = self.cellTypes(indexPath: indexPath) else {
            return nil
        }
        currentIndexTuple = (type: type, indexPath: indexPath)
        return type
    }
    
    var getNumOfSection: Int {
        return T.allCases.count
    }
    
    func getHeaderTitle(section: Int) -> String {
        guard section >= 0 && section < T.allCases.count else {
            return "Invalid Section"
        }
        let array = Array(T.allCases)
        return array[section].getHeaderTitle
    }
    
    func getNumOfCell(section: Int) -> Int {
        return cellTypesDictionary[section]?.count ?? 0
    }
    
    func getLastCell(indexPath: IndexPath) -> Bool {
        return (cellTypesDictionary[indexPath.section]?.count ?? 0) - 1 == indexPath.row
    }
    
    var getBottomBtnTitle: String? {
        return T.allCases.first?.bottomBtnTitle(isMake: isMake)
    }
    
    var getNavTitle: String? {
        return T.allCases.first?.getNavTitle(isMake: isMake)
    }
    
    func validation() async throws {
        guard let type = T.allCases.first else {
            throw ErrorEnum.unknownError
        }
        
        try await validateType(type: type)
    }
    
    private func validateType(type: EditScreenType) async throws {
        switch type {
        case is RoomEditEnum:
            guard roomValidation(type: RoomEditCellType.self) else { throw ErrorEnum.unknownError }
            
            let room = try await createRoom()
            
            self.roomDataClosure?(room)
            
        case is ProfileEditEnum:
            guard roomValidation(type: ProfileEditCellType.self) else { throw ErrorEnum.unknownError }
            
            let user = try await createUser()
            
            self.userDataClosure?(user)
            
        default:
            throw ErrorEnum.unknownError
        }
    }
    
    private func roomValidation<Q: EditCellType & CaseIterable>(type: Q.Type) -> Bool {
        return Q.allCases.allSatisfy { changedData.keys.contains($0.databaseString) }
    }
    
    private func createRoom() async throws -> Rooms {
        guard let api = self.api as? RoomEditAPIType else {
            throw ErrorEnum.unknownError
        }
        let dict = changedData.compactMapValues { $0 }
        return try await api.createData(dict: dict)
    }
    
    private func createUser() async throws -> User {
        guard let api = self.api as? ProfileEditAPIType else {
            throw ErrorEnum.unknownError
        }
        let dict = changedData.compactMapValues { $0 }
        return try await api.createData(dict: dict)
    }
}
