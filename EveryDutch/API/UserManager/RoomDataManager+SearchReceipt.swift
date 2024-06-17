//
//  RoomDataManager+SearchReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 6/13/24.
//

import Foundation
extension RoomDataManager {
    
    // MARK: - 데이터 fetch
    func loadUserReceipt(
        completion: @escaping Typealias.IndexPathsCompletion
    ) {
        // 검색 모드로 변환
        self.updateSearchMode(searchMode: true)
        // 버전ID 및 현재 유저ID 가져오기
        guard let versionID = self.getCurrentVersion,
              let userID = getCurrentUserID else {
            completion(.failure(.readError))
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.loadInitialUserReceipts(
                userID: userID,
                versionID: versionID
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    print("영수증 가져오기 성공")
                    let newIndexPaths = self.handleAddedUserReceipt(initialLoad)
                    completion(.success(newIndexPaths))
                case .failure(let error):
                    completion(.failure(error))
                    print("영수증 가져오기 실패")
                }
            }
        }
    }

    func loadMoreUserReceipt(
        completion: @escaping Typealias.IndexPathsCompletion
    ) {
        guard let versionID = self.getCurrentVersion,
              let userID = getCurrentUserID else {
            completion(.failure(.readError))
            return
        }
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.loadMoreReceipts(
                userID: userID,
                versionID: versionID
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let moreLoad):
                    print("영수증 추가 가져오기 성공")
                    let newIndexPaths = self.handleAddedUserReceipt(moreLoad)
                    completion(.success(newIndexPaths))
                case .failure(let error):
                    completion(.failure(error))
                    print("영수증 추가 가져오기 실패")
                }
            }
        }
    }

    @discardableResult
    private func handleAddedUserReceipt(_ receiptTuple: [ReceiptTuple]) -> [IndexPath] {
        var newIndexPaths = [IndexPath]()
        
        for (receiptID, room) in receiptTuple {
            let indexPath = IndexPath(row: self.userReceiptCellViewModels.count, section: 0)
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
            self.userReceiptCellViewModels.append(viewModel)
            newIndexPaths.append(indexPath)
        }
        
        return newIndexPaths
    }
}
