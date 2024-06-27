//
//  RoomDataManager+ReceiptSearchMode.swift
//  EveryDutch
//
//  Created by 계은성 on 6/27/24.
//

import Foundation

extension RoomDataManager {
    
    func loadUserReceipt(completion: @escaping Typealias.VoidCompletion) {
        guard let versionID = self.getCurrentVersion,
              let userID = self.getCurrentUserID 
        else {
            //            self.errorClosure?(.readError)
            return
        }
        
        self.receiptAPI.loadInitialUserReceipts(userID: userID,
                                                versionID: versionID
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let load):
                // 영수증 데이터를 성공적으로 가져옴
                print("영수증 가져오기 성공")
//                self.handleAddedReceiptEvent(
//                    load,
//                    sections: &self.receiptSearchModeSections
//                )
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("영수증 가져오기 실패")
                    // 영수증 데이터를 가져오지 못한 경우 오류를 반환
                    //                    self.errorClosure?(error)
                }
            }
        }
        
    }
    
    
    func loadMoreUserReceipt() {
        guard let versionID = self.getCurrentVersion,
              let userID = self.getCurrentUserID 
        else {
            //            self.errorClosure?(.readError)
            return
        }
        self.receiptAPI.loadMoreUserReceipts(userID: userID,
                                             versionID: versionID
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let load):
                // 영수증 데이터를 성공적으로 가져옴
                print("영수증 가져오기 성공")
//                self.handleAddedReceiptEvent(
//                    load,
//                    sections: &self.receiptSearchModeSections
//                )
                
                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("영수증 가져오기 실패")
                    // 영수증 데이터를 가져오지 못한 경우 오류를 반환
                    //                    self.errorClosure?(error)
                }
            }
        }
    }
}
