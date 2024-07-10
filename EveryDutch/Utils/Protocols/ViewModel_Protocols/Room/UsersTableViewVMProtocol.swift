//
//  UsersTableViewVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

protocol UsersTableViewVMProtocol {
    
    
    var userCardDataClosure: (() -> Void)? { get set }
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    
    
    var numbersOfUsers: Int { get }
    
    var isFirstBtnTapped: Bool { get set }
    var getBtnColor: [UIColor] { get }
    
    var tableViewIsScrollEnabled: Bool { get }
    
    func cellViewModel(at index: Int) -> UsersTableViewCellVMProtocol?
//    func makeCellVM()
    
    
    
    func selectUser(index: Int)
    
    func validateRowCountChange(
        currentRowCount: Int,
        changedUsersCount: Int
    ) -> Bool
    
    func validateRowExistenceForUpdate(
        indexPaths: [IndexPath],
        totalRows: Int
    ) -> Bool
    
    
    // User data handling
    func userDataChanged(_ userInfo: [String: Any])
    func getPendingUserDataIndexPaths() -> [(key: String, indexPaths: [IndexPath])]
    func resetPendingUserDataIndexPaths()
}
