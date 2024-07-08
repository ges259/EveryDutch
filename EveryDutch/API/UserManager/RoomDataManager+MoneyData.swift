//
//  RoomDataManager+MoneyData.swift
//  EveryDutch
//
//  Created by 계은성 on 5/11/24.
//

import UIKit

extension RoomDataManager {
    // 두 데이터 로드 작업을 실행하고 모두 완료되면 콜백을 호출
    func loadFinancialData() {
        guard let versionID = self.getCurrentVersion else { return }
        // 데이터 초기화
        self.userDebouncer.reset()
        
        // 누적 금액 가져오기
        self.loadCumulativeAmountData(versionID: versionID)
        // 페이백 금액 가져오기
        self.loadPaybackData(versionID: versionID)
    }
    
    // MARK: - 누적 금액 데이터
    private func loadCumulativeAmountData(versionID: String) {
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.readCumulativeAmount(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let moneyData):
                    print("cumulativeMoney 성공")
                    self.updateCumulativeAmount(moneyData)
                    
                    break
                case .failure:
                    DispatchQueue.main.async {
                        print("cumulativeMoney 실패")
                    }
                    break
                }
            }
        }
    }
    
    // MARK: - 페이백 데이터
    private func loadPaybackData(versionID: String) {
        DispatchQueue.global(qos: .utility).async {
            self.roomsAPI.readPayback(versionID: versionID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let moneyData):
                    print("payback 성공")
                    DispatchQueue.main.async {
                        self.updatePayback(moneyData)
                    }
                    break
                    
                case .failure:
                    DispatchQueue.main.async {
                        print("payback 실패")
                    }
                    break
                }
            }
        }
    }
    // User not found in the mapping
    /// 누적 금액 데이터 변경
    private func updateCumulativeAmount(_ amount: [String: Int]) {
        for (key, value) in amount {
            guard let indexPath = self.userIDToIndexPathMap[key],
                  indexPath.row < self.usersCellViewModels.count
            else {
                continue
            }
            self.usersCellViewModels[indexPath.row].setCumulativeAmount(value)
            self.userDebouncer.triggerDebounceWithIndexPaths(eventType: .updated, [indexPath])
        }
    }
    
    /// 페이백 데이터 변경
    private func updatePayback(_ payback: [String: Int]) {
        for (key, value) in payback {
            guard let indexPath = self.userIDToIndexPathMap[key],
                  indexPath.row < self.usersCellViewModels.count
            else {
                print("User not found in the mapping. ----- payback")
                continue
            }
            self.usersCellViewModels[indexPath.row].setPayback(value)
            self.userDebouncer.triggerDebounceWithIndexPaths(eventType: .updated, [indexPath])
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
