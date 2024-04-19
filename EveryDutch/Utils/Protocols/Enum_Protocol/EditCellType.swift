//
//  EditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation


// : EditProviderEnumType
// MARK: - EditCellType
protocol EditCellType {
    
    // MARK: - 셀 타이틀
    var getCellTitle: String { get }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String { get }
    
    var databaseString: String { get }
    
}











//// MARK: - Provider패턴
//
//protocol EditProviderEnumType {}
//
//protocol EditDataProvider {
//    func canProvideData(for cellType: EditProviderEnumType) -> Bool
//    func provideData(for cellType: EditProviderEnumType) -> String?
////    func updateData<T>(with newData: T)
//}
//
//
//
//// MARK: - UserDataProvider
//// User 데이터를 처리하는 프로바이더
//class UserDataProvider: EditDataProvider {
//    private var userData: User?
//
//    init(userData: User?) {
//        self.userData = userData
//    }
//    deinit { print("\(#function)-----\(self)") }
//
//    
//    func canProvideData(for cellType: EditProviderEnumType) -> Bool {
//        return cellType is ProfileEditCellType
//        || cellType is UserInfoType
//    }
//    
//    
//    func provideData(for cellType: EditProviderEnumType) -> String? {
//        
//        if cellType is ProfileEditCellType {
//            
//        }
//        
//        switch cellType {
//        case let cell as ProfileEditCellType:
//            return cell.detail(for: self.userData)
//            
//        case let cell as UserInfoType:
//            return cell.detail(from: self.userData)
//            
//        default:
//            return nil
//        }
//    }
////    func updateData<T>(with newData: T) {
////        if let user = newData as? User {
////            self.userData = user
////        }
////    }
//}
//
//// MARK: - RoomsDataProvider
//// Rooms 데이터를 처리하는 프로바이더
//
//class RoomsDataProvider: EditDataProvider {
//
//    
//    private var roomsData: Rooms?
//
//    init(roomsData: Rooms?) {
//        self.roomsData = roomsData
//    }
//    deinit { print("\(#function)-----\(self)") }
//
//    
//    func canProvideData(for cellType: EditProviderEnumType) -> Bool {
//        return cellType is RoomEditCellType
//    }
//    func provideData(for cellType: EditProviderEnumType) -> String? {
//        switch cellType {
//        case let cell as RoomEditCellType:
//            return cell.detail(for: self.roomsData)
//            
//        default:
//            return nil
//        }
//    }
//}
//
//
//// MARK: - DecorationDataProvider
//// Decoration 데이터를 처리하는 프로바이더
//class DecorationDataProvider: EditDataProvider {
//    private var decorationData: Decoration?
//    
//    init(decorationData: Decoration?) {
//        self.decorationData = decorationData
//    }
//    deinit { print("\(#function)-----\(self)") }
//    
//    
//    func canProvideData(for cellType: EditProviderEnumType) -> Bool {
//        return cellType is DecorationCellType
////        cellType is ImageCellType
////            ||
//    }
//    
//    func provideData(for cellType: EditProviderEnumType) -> String? {
//        switch cellType {
////        case let cell as ImageCellType:
////            return cell.detail(for: decorationData)
//            
//        case let cell as DecorationCellType:
//            return cell.detail(for: self.decorationData)
//            
//        default:
//            return nil
//        }
//    }
//}
//
//        
