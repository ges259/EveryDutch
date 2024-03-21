//
//  SettingVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

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
