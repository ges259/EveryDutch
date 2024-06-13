//
//  RoomDataManager+SearchReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 6/13/24.
//

import Foundation

extension RoomDataManager {
    // MARK: - 데이터 fetch
    func loadUserReceipt(completion: @escaping Typealias.VoidCompletion) {
        self.isSearchMode = true
        
        // 버전 ID 가져오기
        guard let versionID = self.getCurrentVersion else {
            completion(.failure(.readError))
            return
        }
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.readRoomReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    
                    print("영수증 가져오기 성공")
                case .failure(let error):
//                    completion(.failure(error))
                    print("영수증 가져오기 실패")
                }
            }
        }
    }
    
    
    /// 데이터를 추가적으로 가져오는 코드
    func loadUserRoomReceipt() {
        
    }
    
    
    private func handleAddedUserReceipt(_ receiptTuple: [ReceiptTuple]) {
        if receiptTuple.isEmpty { return }
        // 리턴할 인덱스패스
        var addedIndexPaths = [IndexPath]()
        
        for (receiptID, room) in receiptTuple {
            // 중복 추가 방지
            guard self.userReceiptIDToIndexPathMap[receiptID] == nil else { continue }
            // 인덱스패스 생성
            let indexPath = IndexPath(row: self.userReceiptCellViewModels.count, section: 0)
            
            // 뷰모델 생성
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
            // 뷰모델 저장
            self.userReceiptCellViewModels.append(viewModel)
            // 인덱스패스 업데이트
            self.userReceiptIDToIndexPathMap[receiptID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        // 변경 사항을 알리는 알림 전송
//        self.receiptDebouncer.triggerDebounceWithIndexPaths(eventType: .added, addedIndexPaths)
        
    }
}
