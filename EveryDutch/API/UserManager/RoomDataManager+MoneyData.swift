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
        self.resetDebounceState()
        self.loadCumulativeAmountData(versionID: versionID)
        self.loadPaybackData(versionID: versionID)
    }
    
    // MARK: - 누적 금액 데이터
    private func loadCumulativeAmountData(versionID: String) {
        self.roomsAPI.readCumulativeAmount(versionID: versionID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moneyData):
                print("cumulativeMoney 성공")
                self.updateCumulativeAmount(moneyData)
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
            guard let self = self else { return }
            switch result {
            case .success(let moneyData):
                print("payback 성공")
                self.updatePayback(moneyData)
                break
                
            case .failure:
                print("payback 실패")
                break
            }
        }
    }
    
    /// 누적 금액 데이터 변경
    private func updateCumulativeAmount(_ amount: [String: Int]) {
        for (key, value) in amount {
            guard let indexPath = self.userIDToIndexPathMap[key],
                  indexPath.row < self.usersCellViewModels.count
            else {
                print("User not found in the mapping.")
                continue
            }
            self.usersCellViewModels[indexPath.row].setCumulativeAmount(value)
            self.saveChangedIndexPaths(indexPath: indexPath)
        }
        self.triggerDebouncing()
    }
    
    /// 페이백 데이터 변경
    private func updatePayback(_ payback: [String: Int]) {
        for (key, value) in payback {
            guard let indexPath = self.userIDToIndexPathMap[key],
                  indexPath.row < self.usersCellViewModels.count
            else {
                print("User not found in the mapping.")
                continue
            }
            self.usersCellViewModels[indexPath.row].setPayback(value)
            self.saveChangedIndexPaths(indexPath: indexPath)
        }
        self.triggerDebouncing()
    }
    
    /// 인덱스패스 저장
    private func saveChangedIndexPaths(indexPath: IndexPath) {
        // 인덱스패스가 포함되어있지 않다면
        if !self.changedIndexPaths.contains(indexPath) {
            // 이덱스패스 저장
            self.changedIndexPaths.append(indexPath)
        }
    }
    
    /// 디바운싱 시작
    func triggerDebouncing() {
        self.debounceWorkItem?.cancel()  // 기존에 스케줄된 작업이 있다면 취소
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.postDebounceNotification()
        }
        
        self.debounceWorkItem = workItem
        self.queue.asyncAfter(deadline: .now() + self.debounceInterval, execute: workItem)
    }
    
    /// 디바운싱 완료 후 노티피케이션 전송
    private func postDebounceNotification() {
        DispatchQueue.main.async {
            // 데이터 업데이트 후 노티피케이션 전송 로직은 유지
            self.postNotification(name: .financialDataUpdated,
                                  eventType: .updated,
                                  indexPath: self.changedIndexPaths)
            self.resetDebounceState()
        }
    }
    
    /// 디바운싱 상태 초기화
    private func resetDebounceState() {
        self.changedIndexPaths = []
        self.debounceWorkItem = nil
    }
}
