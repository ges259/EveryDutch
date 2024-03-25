//
//  EditCellType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation


protocol Providers {}


// MARK: - EditCellType
protocol EditCellType: Providers {
    
    // MARK: - 셀 타이틀
    var getCellTitle: String { get }
    
    // MARK: - 플레이스홀더 타이틀
    var getTextFieldPlaceholder: String { get }
    
    var databaseString: String { get }
}







protocol DataProvider {
    func provideData(for cellType: Providers) -> String?
}

// User 데이터를 처리하는 프로바이더
class UserDataProvider: DataProvider {
    private var userData: User?

    init(userData: User?) {
        self.userData = userData
    }

    func provideData(for cellType: Providers) -> String? {
        guard let userData = self.userData else { return nil }
        
        switch cellType {
        case let cell as ProfileEditCellType:
            return cell.detail(for: userData)
            
        case let cell as UserInfoType:
            return cell.detail(from: userData)
            
        default:
            return nil
        }
    }
}

// Rooms 데이터를 처리하는 프로바이더
class RoomsDataProvider: DataProvider {

    
    private var roomsData: Rooms?

    init(roomsData: Rooms?) {
        self.roomsData = roomsData
    }

    
    func provideData(for cellType: Providers) -> String? {
        guard let roomsData = self.roomsData else { return nil }
        switch cellType {
        case let cell as RoomEditCellType:
            return cell.detail(for: roomsData)
            
        default:
            return nil
        }
    }
}

// Decoration 데이터를 처리하는 프로바이더
class DecorationDataProvider: DataProvider {
    private var decorationData: Decoration?
    
    init(decorationData: Decoration?) {
        self.decorationData = decorationData
    }
    
    
    func provideData(for cellType: Providers) -> String? {
        guard let decorationData = decorationData else { return nil }
        
        switch cellType {
        case let cell as ImageCellType:
            return cell.detail(for: decorationData)
            
        case let cell as DecorationCellType:
            return cell.detail(for: decorationData)
            
        default:
            return nil
        }
    }
}

        
