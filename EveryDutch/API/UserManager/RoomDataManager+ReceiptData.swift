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
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.readReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let initialLoad):
                    print("영수증 가져오기 성공")
                    self.updateReceipt(initialLoad)
                case .failure(_):
                    DispatchQueue.main.async {
                        print("영수증 가져오기 실패")
                    }
                }
            }
        }
    }
    /// 데이터를 추가적으로 가져오는 코드
    func loadMoreReceiptData() {
        guard self.hasMoreData,
              let versionID = self.getCurrentVersion else { return }
        DispatchQueue.global(qos: .utility).async {
            self.receiptAPI.loadMoreReceipts(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let loadData):
                    self.handleAddedMoreReceiptData(loadData)
                case .failure(let error):
                    DispatchQueue.main.async {
                        switch error {
                        case .noMoreData:
                            self.hasMoreData = false
                            break
                        default:
                            break
                        }
                        print("영수증 추가적으로 가져오기 실패")
                    }
                }
            }
        }
    }
    

    
    // MARK: - 업데이트 설정
    private func updateReceipt(_ event: DataChangeEvent<[ReceiptTuple]>) {
        switch event {
        case .updated(let toUpdate):
            print("\(#function) ----- update")
            self.handleUpdatedReceiptEvent(toUpdate)
            
        case .initialLoad(let userDict):
            print("\(#function) ----- init")
            self.handleInitialLoadReceiptEvent(userDict)
        case .added(let toAdd):
            print("\(#function) ----- add")
            self.handleAddedReceiptEvent(toAdd)
            
        case .removed(let roomID):
            print("\(#function) ----- remove")
            self.handleRemovedReceiptEvent(roomID)
        }
    }
    
    // MARK: - 업데이트
    private func handleUpdatedReceiptEvent(_ toUpdate: [String: [String: Any]]) {
        if toUpdate.isEmpty { return }
        
        // 리턴할 인덱스패스
        var updatedIndexPaths = [IndexPath]()
        
        for (receiptID, changedData) in toUpdate {
            if let indexPath = self.receiptIDToIndexPathMap[receiptID] {
                // 뷰모델에 바뀐 데이터 저장
                self.receiptCellViewModels[indexPath.row].updateReceipt(changedData)
                updatedIndexPaths.append(indexPath)
            }
        }
        self.postNotification(name: .receiptDataChanged, eventType: .updated, indexPath: updatedIndexPaths)
    }
    
    // MARK: - 초기 설정
    private func handleInitialLoadReceiptEvent(_ userDict: [ReceiptTuple]) {
        if userDict.isEmpty { return }
        
        // 리턴할 인덱스패스
        var addedIndexPaths = [IndexPath]()
        
        // 초기 로드일 때 모든 데이터 초기화
        self.receiptCellViewModels.removeAll()
        self.receiptIDToIndexPathMap.removeAll()
        
        // 모든 데이터 추가
        for (index, (receiptID, room)) in userDict.enumerated() {
            // 인덱스 패스 생성
            let indexPath = IndexPath(row: index, section: 0)
            // 뷰모델 생성
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
            // 뷰모델 저장
            self.receiptCellViewModels.append(viewModel)
            // 인덱스패스 저장
            self.receiptIDToIndexPathMap[receiptID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        
        print("addedIndexPaths 개수 ----- \(addedIndexPaths.count)")
        self.postNotification(
            name: .receiptDataChanged,
            eventType: .initialLoad,
            indexPath: addedIndexPaths)
    }
    
    // MARK: - 생성
    private func handleAddedReceiptEvent(_ toAdd: [ReceiptTuple]) {
        
        print("_________________________________________")
        print("toAdd ----- \(toAdd)")
        print("_________________________________________")
        if toAdd.isEmpty { return }

        // 리턴할 인덱스패스
        var addedIndexPaths = [IndexPath]()
        for (receiptID, room) in toAdd {
            // 중복 추가 방지
            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
            // 인덱스패스 생성 (뷰모델 추가 전에 현재 count 사용)
            let indexPath = IndexPath(row: self.receiptCellViewModels.count, section: 0)
            
            // 뷰모델 생성
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
            // 뷰모델 저장
            self.receiptCellViewModels.append(viewModel)
            // 인덱스패스 업데이트
            self.receiptIDToIndexPathMap[receiptID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        
        self.postNotification(name: .receiptDataChanged, eventType: .added, indexPath: addedIndexPaths)
    }
    /// 데이터를 추가적으로 가져올 때
    private func handleAddedMoreReceiptData(_ toAdd: [ReceiptTuple]) {
        print(#function)
        if toAdd.isEmpty {
            self.hasMoreData = false
            return
        }
        // 리턴할 인덱스패스
        var addedIndexPaths = [IndexPath]()
        let currentCount = self.receiptCellViewModels.count
        
        for (index, (receiptID, room)) in toAdd.enumerated() {
            // 중복 추가 방지
            guard self.receiptIDToIndexPathMap[receiptID] == nil else { continue }
            // 인덱스패스 생성
            let indexPath = IndexPath(row: currentCount + index, section: 0)
            
            // 뷰모델 생성
            let viewModel = ReceiptTableViewCellVM(receiptID: receiptID, receiptData: room)
            // 뷰모델 저장
            self.receiptCellViewModels.append(viewModel)
            // 인덱스패스 업데이트
            self.receiptIDToIndexPathMap[receiptID] = indexPath
            addedIndexPaths.append(indexPath)
        }
        self.postNotification(name: .receiptDataChanged, eventType: .added, indexPath: addedIndexPaths)
    }
    
    // MARK: - 삭제
    private func handleRemovedReceiptEvent(_ receiptID: String) {
        // 리턴할 인덱스패스
        var removedIndexPaths = [IndexPath]()
        
        if let indexPath = self.receiptIDToIndexPathMap[receiptID] {
            // 뷰모델 삭제
            self.receiptCellViewModels.remove(at: indexPath.row)
            // 인덱스패스 삭제
            self.receiptIDToIndexPathMap.removeValue(forKey: receiptID)
            // 데이터 삭제
            removedIndexPaths.append(indexPath)
            // 삭제 후 인덱스 재정렬
            for row in indexPath.row..<self.receiptCellViewModels.count {
                // 새로운 인덱스패스 생성
                let newIndexPath = IndexPath(row: row, section: 0)
                // 해당 인덱스의 뷰모델에 있는 receiptID를 가져옴
                let newReceiptID = self.receiptCellViewModels[row].getReceiptID
                self.receiptIDToIndexPathMap[newReceiptID] = newIndexPath
            }
        }
        self.postNotification(name: .receiptDataChanged, eventType: .removed, indexPath: removedIndexPaths)
    }
}



// MARK: - 옵저버 설정
//    func setObserveReceipt() {
//        guard let versionID = self.getCurrentVersion else { return }
//        DispatchQueue.global(qos: .utility).async {
//            self.receiptAPI.observeReceipt(versionID: versionID) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let rooms):
//                    print("Receipt 옵저버 성공")
//                    self.updateReceipt(rooms)
//                    break
//                case .failure(_):
//                    DispatchQueue.main.async {
//                        print("Receipt 옵저버 실패")
//                    }
//                    break
//                }
//            }
//        }
//    }
