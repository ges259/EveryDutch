//
//  RoomDataManager+ReceiptData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/12/24.
//

import Foundation

extension RoomDataManager {
    
    // MARK: - 데이터 fetch
    func loadReceipt() {
        guard let versionID = self.getCurrentVersion else { return }
        self.receiptAPI.readReceipt(versionID: versionID) { [weak self] result in
            switch result {
            case .success(let initialLoad):
                print("영수증 가져오기 성공")
                self?.setObserveReceipt()
                self?.updateReceipt(initialLoad)
                
                break
            case .failure(_):
                print("영수증영수증 가져오기 실패")
                break
            }
        }
    }
    
    // MARK: - 옵저버 설정
    private func setObserveReceipt() {
        guard let versionID = self.getCurrentVersion else { return }
        self.receiptAPI.observeReceipt(versionID: versionID) { [weak self] result in
            switch result {
            case .success(let rooms):
                print("Receipt 옵저버 성공")
                self?.updateReceipt(rooms)
                break
                
            case .failure(_):
                print("Receipt 옵저버 실패")
                break
            }
        }
    }
    
    // MARK: - 업데이트 설정
    private func updateReceipt(_ event: (DataChangeEvent<[ReceiptTuple]>)) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            // 리턴할 인덱스패스
            var updatedIndexPaths = [IndexPath]()
            
            for (userID, changedData) in toUpdate {
                if let indexPath = self.receiptIDToIndexPathMap[userID] {
                    // 뷰모델에 바뀐 user데이터 저장
                    self.receiptCellViewModels[indexPath.row].updateReceipt(changedData)
                    updatedIndexPaths.append(indexPath)
                }
            }
            self.postNotification(name: .receiptDataChanged,
                                  eventType: .updated,
                                  indexPath: updatedIndexPaths)
            
            
            // 데이터 초기 로드
        case .initialLoad(let userDict):
            print("\(#function) ----- init")
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()

            // 초기 로드일 때 모든 데이터 초기화
            self.receiptCellViewModels.removeAll()
            self.receiptIDToIndexPathMap.removeAll()
            
            // 모든 데이터 추가
            for (index, (roomID, room)) in userDict.enumerated() {
                // 인덱스 패스 생성
                let indexPath = IndexPath(row: index, section: 0)
                // 뷰모델 생성
                let viewModel = ReceiptTableViewCellVM(receiptID: roomID,
                                                       receiptData: room)
                // 뷰모델 저장
                self.receiptCellViewModels.append(viewModel)
                // 인덱스패스 저장
                self.receiptIDToIndexPathMap[roomID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            self.postNotification(name: .receiptDataChanged,
                                  eventType: .initialLoad,
                                  indexPath: addedIndexPaths)
            
            
        case .added(let toAdd):
            print("\(#function) ----- add")
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()
            for (roomID, room) in toAdd {
                // 중복 추가 방지
                guard self.receiptIDToIndexPathMap[roomID] == nil else { continue }
                // 인덱스패스 생성 (뷰모델 추가 전에 현재 count 사용)
                let indexPath = IndexPath(row: self.receiptCellViewModels.count, section: 0)
                
                // 뷰모델 생성
                let viewModel = ReceiptTableViewCellVM(receiptID: roomID,
                                                       receiptData: room)
                // 뷰모델 저장
                self.receiptCellViewModels.append(viewModel)
                // 인덱스패스 업데이트
                self.receiptIDToIndexPathMap[roomID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            self.postNotification(name: .receiptDataChanged,
                                  eventType: .added,
                                  indexPath: addedIndexPaths)
            
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            // 리턴할 인덱스패스
            var removedIndexPaths = [IndexPath]()

            if let indexPath = self.receiptIDToIndexPathMap[roomID] {
                // 뷰모델 삭제
                self.receiptCellViewModels.remove(at: indexPath.row)
                // 인덱스패스 삭제
                self.receiptIDToIndexPathMap.removeValue(forKey: roomID)
                // [String: User] 데이터 삭제
                removedIndexPaths.append(indexPath)
                // 삭제 후 인덱스 재정렬 (인덱스 매핑 최적화)
                for row in indexPath.row..<self.receiptCellViewModels.count {
                    // 새로운 인덱스패스 생성
                    let newIndexPath = IndexPath(row: row, section: 0)
                    // 해당 인덱스의 뷰모델에 있는 roomID를 가져옴
                    let roomID = self.receiptCellViewModels[row].getReceiptID
                    self.receiptIDToIndexPathMap[roomID] = newIndexPath
                }
            }
            self.postNotification(name: .receiptDataChanged,
                                  eventType: .removed,
                                  indexPath: removedIndexPaths)
        }
    }
}
