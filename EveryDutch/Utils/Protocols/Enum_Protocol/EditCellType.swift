//
//  EditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation



// MARK: - EditCellType
protocol EditCellType: Providers {
    
    // MARK: - 셀 타이틀
    var getCellTitle: String { get }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String { get }
    
    var databaseString: String { get }
}




// MARK: - 팩토리 패턴
//class DataProviderFactory {
//    static func createProviders(
//        user: User?,
//        rooms: Rooms?,
//        decoration: Decoration?)
//    -> [DataProvider] {
//        
//        var providers: [DataProvider] = []
//        
//        if let user = user {
//            providers.append(UserDataProvider(userData: user))
//        }
//        
//        if let rooms = rooms {
//            providers.append(RoomsDataProvider(roomsData: rooms))
//        }
//        
//        if let decoration = decoration {
//            providers.append(DecorationDataProvider(decorationData: decoration))
//        }
//        return providers
//    }
//}










// MARK: - Provider패턴

protocol Providers {}

protocol DataProvider {
    func canProvideData(for cellType: Providers) -> Bool
    func provideData(for cellType: Providers) -> String?
//    func updateData<T>(with newData: T)
}



// MARK: - UserDataProvider
// User 데이터를 처리하는 프로바이더
class UserDataProvider: DataProvider {
    private var userData: User?

    init(userData: User?) {
        self.userData = userData
    }
    deinit { print("\(#function)-----\(self)") }

    
    func canProvideData(for cellType: Providers) -> Bool {
        return cellType is ProfileEditCellType
        || cellType is UserInfoType
    }
    
    
    func provideData(for cellType: Providers) -> String? {
        switch cellType {
        case let cell as ProfileEditCellType:
            return cell.detail(for: userData)
            
        case let cell as UserInfoType:
            return cell.detail(from: userData)
            
        default:
            return nil
        }
    }
//    func updateData<T>(with newData: T) {
//        if let user = newData as? User {
//            self.userData = user
//        }
//    }
}

// MARK: - RoomsDataProvider
// Rooms 데이터를 처리하는 프로바이더

class RoomsDataProvider: DataProvider {

    
    private var roomsData: Rooms?

    init(roomsData: Rooms?) {
        self.roomsData = roomsData
    }
    deinit { print("\(#function)-----\(self)") }

    
    func canProvideData(for cellType: Providers) -> Bool {
        return cellType is RoomEditCellType
    }
    func provideData(for cellType: Providers) -> String? {
        switch cellType {
        case let cell as RoomEditCellType:
            return cell.detail(for: self.roomsData)
            
        default:
            return nil
        }
    }
    
//    func updateData<T>(with newData: T) {
//        if let rooms = newData as? Rooms {
//            self.roomsData = rooms
//        }
//    }
}


// MARK: - DecorationDataProvider
// Decoration 데이터를 처리하는 프로바이더
class DecorationDataProvider: DataProvider {
    private var decorationData: Decoration?
    
    init(decorationData: Decoration?) {
        self.decorationData = decorationData
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    func canProvideData(for cellType: Providers) -> Bool {
        return cellType is ImageCellType
            || cellType is DecorationCellType
    }
    
    func provideData(for cellType: Providers) -> String? {
        switch cellType {
        case let cell as ImageCellType:
            return cell.detail(for: decorationData)
            
        case let cell as DecorationCellType:
            return cell.detail(for: decorationData)
            
        default:
            return nil
        }
    }
//    func updateData<T>(with newData: T) {
//        if let decoration = newData as? Decoration {
//            self.decorationData = decoration
//        }
//    }
}

        
