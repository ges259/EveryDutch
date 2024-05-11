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
        self.resetMoneyData()
        self.loadCumulativeAmountData(versionID: versionID)
        self.loadPaybackData(versionID: versionID)
    }

    // MARK: - 누적 금액 데이터
    private func loadCumulativeAmountData(versionID: String) {
        self.roomsAPI.readCumulativeAmount(versionID: versionID) { [weak self] result in
            switch result {
            case .success(let moneyData):
                print("cumulativeMoney 성공")
                dump(moneyData)
                self?.updateCumulativeAmount(moneyData)
                self?.markAsLoaded(self?.cumulativeAmountLoadedKey ?? "")
                self?.trySendNotification()
                break
            case .failure:
                print("cumulativeMoney 실패")
                break
            }
        }
    }

    // MARK: - 페이백 데이터
    private func loadPaybackData(versionID: String) {
        self.roomsAPI.readPayback(versionID: versionID) { [weak self] result in
            switch result {
            case .success(let moneyData):
                print("payback 성공")
                self?.updatePayback(moneyData)
                self?.markAsLoaded(self?.paybackLoadedKey ?? "")
                self?.trySendNotification()
                break
                
            case .failure:
                print("payback 실패")
                break
            }
        }
    }

    // 누적 금액 데이터 변경
    private func updateCumulativeAmount(_ amount: [String: Int]) {
        for (key, value) in amount {
            guard let indexPath = self.userIDToIndexPathMap[key] else {
                print("User not found in the mapping.")
                continue
            }
            let index = indexPath.row
            if index < self.cellViewModels.count {
                self.cellViewModels[index].setCumulativeAmount(value)
                self.changedIndexPaths.append(indexPath)
            }
        }
    }

    // 페이백 데이터 변경
    private func updatePayback(_ payback: [String: Int]) {
        for (key, value) in payback {
            guard let indexPath = self.userIDToIndexPathMap[key] else {
                print("User not found in the mapping.")
                continue
            }
            let index = indexPath.row
            if index < self.cellViewModels.count {
                self.cellViewModels[index].setpayback(value)
                self.changedIndexPaths.append(indexPath)
            }
        }
    }

    
    
    // 상태 추적용 마킹 함수
    private func markAsLoaded(_ key: String) {
        self.loadedStates.insert(key)
    }
    
    // 모든 데이터 로드 완료 여부 확인
    private func allDataLoaded() -> Bool {
        return self.loadedStates.contains(cumulativeAmountLoadedKey) && self.loadedStates.contains(paybackLoadedKey)
    }
    // 모든 데이터가 로드되었는지 확인하고 노티피케이션 전송
    private func trySendNotification() {
        if self.allDataLoaded() {
            print(#function)
            print(self.changedIndexPaths)
            print(self.changedIndexPaths.count)
            print("____________")
            NotificationCenter.default.post(
                name: .financialDataUpdated,
                object: nil,
                userInfo: ["updated": self.changedIndexPaths]
            )
            // 모든 데이터가 로드되었으므로 상태 초기화
            self.resetMoneyData()
        }
    }
    
    private func resetMoneyData() {
        self.loadedStates = []
        self.changedIndexPaths = []
    }
}
