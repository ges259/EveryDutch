//
//  RoomDataManager+SearchReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 6/13/24.
//

import Foundation

extension RoomDataManager {

    /// 사용자의 영수증을 가져오는 함수
    /// 초기 로드 시 검색 모드로 전환하고 영수증을 가져옴
    func fetchUserReceipt(completion: @escaping Typealias.IndexPathsCompletion) {
        print(#function)
        // 검색 모드로 변환
        self.updateSearchMode(searchMode: true)
        // 영수증 데이터를 가져옴
        self.fetchReceipts(completion: completion)
    }

    /// 영수증 데이터를 가져오는 함수
    /// completion 핸들러를 통해 결과를 반환
    private func fetchReceipts(completion: @escaping Typealias.IndexPathsCompletion) {
        print(#function)
        // 버전ID 및 현재 유저ID 가져오기
        // 만약 버전ID나 유저ID를 가져오지 못하면 읽기 오류를 반환하고 종료
        guard let versionID = self.getCurrentVersion,
              let userID = self.getCurrentUserID else {
            completion(.failure(.readError))
            return
        }

        // firstLoadSuccess 플래그를 기반으로 초기 로드 함수 또는 추가 로드 함수를 선택
        // 첫 번째 매개변수: userID
        // 두 번째 매개변수: versionID
        // 세 변째 매개변수: Result<[ReceiptTuple], ErrorEnum>타입의 결과를 반환하는 클로저
        let fetchFunction: (
            String,
            String,
            @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
        ) -> Void 
        // !self.firstLoadSuccess가 true인지 false인지 판단
        = !self.userReceiptLoadSuccess
        // !self.firstLoadSuccess의 결과에 따라 fetchFunction에 다른 함수 저장
        ? self.receiptAPI.loadInitialUserReceipts
        : self.receiptAPI.loadMoreUserReceipts
        
        // 비동기적으로 영수증 데이터를 가져옴
        DispatchQueue.global(qos: .utility).async {
            fetchFunction(userID, versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let load):
                    // 영수증 데이터를 성공적으로 가져옴
                    print("영수증 가져오기 성공")
                    let newIndexPaths = self.handleAddedUserReceipt(load)
                    // 첫 번째 로드 성공 여부를 true로 설정
                    self.userReceiptLoadSuccess = true
                    DispatchQueue.main.async {
                        // 성공한 경우 새로운 인덱스 패스를 반환
                        completion(.success(newIndexPaths))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("영수증 가져오기 실패")
                        // 영수증 데이터를 가져오지 못한 경우 오류를 반환
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    /// 영수증 데이터를 추가하는 함수
    /// 새로운 인덱스 패스를 반환
    @discardableResult
    private func handleAddedUserReceipt(_ receiptTuple: [ReceiptTuple]) -> [IndexPath] {
        var newIndexPaths = [IndexPath]()
        print(#function)
        // 영수증 데이터 튜플을 순회하면서 각 영수증 데이터를 처리
        for (receiptID, room) in receiptTuple {
            // 새로운 인덱스 패스를 생성
            let indexPath = IndexPath(
                row: self.userReceiptCellViewModels.count,
                section: 0)
            // 새로운 뷰모델을 생성
            let viewModel = ReceiptTableViewCellVM(
                receiptID: receiptID,
                receiptData: room)
            // 뷰모델을 배열에 추가
            self.userReceiptCellViewModels.append(viewModel)
            // 새로운 인덱스 패스를 배열에 추가
            newIndexPaths.append(indexPath)
        }
        
        // 새로운 인덱스 패스를 반환
        return newIndexPaths
    }
}
