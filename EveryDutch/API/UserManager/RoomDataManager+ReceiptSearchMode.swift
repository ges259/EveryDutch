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
              let userID = self.getSelectedUserID 
        else {
            self.receiptDebouncer.triggerErrorDebounce(.readError)
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
                self.handleAddedReceiptEvent(
                    load,
                    sections: &self.receiptSearchModeSections
                )
                
                completion(.success(()))
                
                
            case .failure(_):
                print("영수증 가져오기 실패")
                // 영수증 데이터를 가져오지 못한 경우 오류를 반환
                completion(.failure(.hasNoAPIData))
                // 여기서는 Error를 debounce를 통해 trigger하지 않음.
                // 이유는, UserProfileVC에서 NoDataView를 띄울 것이기 때문
            }
        }
    }
    
    
    func loadMoreUserReceipt() {
        guard let versionID = self.getCurrentVersion,
              let userID = self.getSelectedUserID 
        else {
            self.receiptDebouncer.triggerErrorDebounce(.readError)
            return
        }
        self.receiptAPI.loadMoreUserReceipts(userID: userID,
                                             versionID: versionID
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let load):
                // 영수증 데이터를 성공적으로 가져옴
                print("영수증 추가적으로 가져오기 성공")
                self.handleAddedReceiptEvent(
                    load,
                    sections: &self.receiptSearchModeSections
                )
                
            case .failure(_):
                print("영수증 추가적으로 가져오기 실패")
                // 영수증 데이터를 가져오지 못한 경우 오류를 반환
                self.receiptDebouncer.triggerErrorDebounce(.hasNoAPIData)
            }
        }
    }
}
