//
//  RoomDataManager+Debouncer.swift
//  EveryDutch
//
//  Created by 계은성 on 6/7/24.
//

import Foundation

final class Debouncer {
    // MARK: - 프로퍼티
    // 기본 프로퍼티
    private let queue: DispatchQueue
    private let interval: CGFloat
    private let notificationName: Notification.Name
    // 인덱스패스 관련 프로퍼티
    private var workItem: DispatchWorkItem?
    private var error: ErrorEnum?
    
    private var indexPathTuple: [String: (index: Int, indexPaths: [IndexPath])] = [:]
    private var currentIndex: Int = 0
    
    // MARK: - 라이프사이클
    init(_ type: DebounceType) {
        self.queue = type.queue
        self.interval = type.interval
        self.notificationName = type.notificationName
    }
    
    // MARK: - 디바운스 설정
    /// 인덱스패스를 저장 후, 디바운스를 설정하는 메서드
    func triggerDebounceWithIndexPaths(
        eventType: DataChangeType,
        _ indexPaths: [IndexPath] = []
    ) {
        // 디바운스 취소
        self.cancelScheduledWork()
        // 인덱스패스 업데이트
        self.addIndexPaths(eventType: eventType, indexPaths: indexPaths)
        // 에러 정보 초기화
        self.error = nil
        // 디바운스
        self.debounce()
    }
    
    /// 인덱스패스를 저장하는 메서드
    private func addIndexPaths(
        eventType: DataChangeType,
        indexPaths: [IndexPath]
    ) {
        guard !indexPaths.isEmpty else { return }
        
        let notiName = eventType.notificationName
        
        if self.indexPathTuple[notiName] == nil {
            self.indexPathTuple[notiName] = (index: currentIndex, indexPaths: [])
            currentIndex += 1
        }
        
        for indexPath in indexPaths {
            if let existingIndexPaths = self.indexPathTuple[notiName]?.indexPaths,
                !existingIndexPaths.contains(indexPath)
            {
                self.indexPathTuple[notiName]?.indexPaths.append(indexPath)
            }
        }
    }
    
    func initialDebounce() {
        self.debounce(interval: 3)
    }
    
    /// 디바운스를 설정하는 메서드
    private func debounce(interval: CGFloat? = nil) {
        // 일정 시간이 지난 후, 동작할 행동 설정
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            print(#function)
            self.postNotification()
        }
        // 행동 저장
        self.workItem = newWorkItem
        
        let timeInterval: CGFloat = interval ?? self.interval
        // 디바운스 설정
        self.queue.asyncAfter(deadline: .now() + timeInterval,
                              execute: newWorkItem)
    }
    
    // MARK: - 에러 디바운스
    /// 인덱스패스를 삭제후, 디바운스를 통해 에러를 post하도록 설정하는 메서드
    func triggerErrorDebounce(_ errorType: ErrorEnum) {
        // 디바운스 취소
        self.cancelScheduledWork()
        // 에러 설정
        self.error = errorType
        
        // 업데이트하지 않음
        self.indexPathTuple = [:]
        // 디바운스 설정
        self.debounce()
    }
    
    // MARK: - 노티피케이션 post
    private func postNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // 노티피케이션 post
            NotificationCenter.default.post(
                name: self.notificationName,
                object: nil,
                userInfo: self.getUserInfoData)
            // 데이터를 초기화
            self.reset()
        }
    }
    let indexPaths: [String: [IndexPath]] = [:]
    /// 노티피케이션에 post할 딕셔너리를 리턴,
    /// 에러가 있다면 ["error" : ErrorEnum]
    /// 에러가 없다면 [String : [IndexPath]]
    private var getUserInfoData: [String: Any] {
        return self.error != nil
        ? [DataChangeType.error.notificationName: self.error!]
        : self.indexPathTuple.mapValues { $0.indexPaths }
    }
    
    // MARK: - 데이터 초기화
    /// 디바운스 취소, 인덱스패스 및 에러 데이터 초기화
    func reset() {
        self.cancelScheduledWork()
        self.indexPathTuple = [:]
        self.error = nil
        self.currentIndex = 0
    }
    
    private func cancelScheduledWork() {
        self.workItem?.cancel()
    }
}


























// MARK: - IndexPathDataManager
final class IndexPathDataManager<T> {
    // MARK: - 모델
    private var indexPathTuple: [String: (index: Int, indexPaths: [IndexPath])] = [:]
    private var _error: ErrorEnum?
    
    
    
    
    
    // MARK: - 데이터 저장
    // 데이터 저장
    func dataChanged(_ userInfo: [String: Any]) {
        // userInfo 딕셔너리의 각 항목에 대해 반복
        for (key, value) in userInfo {
            // value가 ErrorEnum 타입인 경우, 에러를 설정하고 로그를 출력
            if let error = value as? ErrorEnum {
                self._error = error
                // 에러 처리
                print("DEBUG: Error received: \(error)")

            // value가 [IndexPath] 타입인 경우, indexPathTuple 딕셔너리에 병합
            } else if let newValues = value as? [IndexPath] {

                // 기존에 동일한 key가 있는 경우, 해당 key의 튜플을 업데이트
                if var existingTuple = self.indexPathTuple[key] {

                    // 기존 indexPaths와 새로운 indexPaths를 병합
                    existingTuple.indexPaths = self.mergeIndexPaths(
                        existingTuple.indexPaths,
                        newValues
                    )

                    // 업데이트된 튜플을 indexPathTuple 딕셔너리에 저장
                    self.indexPathTuple[key] = existingTuple

                // 동일한 key가 없는 경우, 새로운 튜플을 생성하여 추가
                } else {
                    self.indexPathTuple[key] = (
                        index: self.indexPathTuple.count, // 새로운 인덱스를 설정
                        indexPaths: newValues
                    )
                }
            }
        }
    }
    
    private func mergeIndexPaths(
        _ existingValues: [IndexPath],
        _ newValues: [IndexPath]
    ) -> [IndexPath] {
        return Array(Set(existingValues + newValues))
    }
    
    
    
    
    
    // MARK: - 데이터 반환
    // 에러 반환
    var error: ErrorEnum? { return self._error }
    
    

    
    func getPendingIndexPaths() -> [(key: String, indexPaths: [IndexPath])] {
        var sectionDict: [Int: [(key: String, indexPaths: [IndexPath])]] = [:]

        // 섹션별로 indexPaths를 분류
        for (key, value) in self.indexPathTuple {
            let indexPaths = value.indexPaths
            
            for indexPath in indexPaths {
                let section = indexPath.section
                if sectionDict[section] == nil {
                    sectionDict[section] = []
                }
                
                // sectionInsert와 sectionRemoved를 맨 앞에 추가
                if key == DataChangeType.sectionInsert.notificationName || key == DataChangeType.sectionRemoved.notificationName {
                    sectionDict[section]?.insert((key: key, indexPaths: [indexPath]), at: 0)
                } else {
                    sectionDict[section]?.append((key: key, indexPaths: [indexPath]))
                }
            }
        }

        var result: [(key: String, indexPaths: [IndexPath])] = []
        
        // 섹션을 오름차순으로 정렬
        let sortedSections = sectionDict.keys.sorted()
        
        for section in sortedSections {
            if let operations = sectionDict[section] {
                // 같은 섹션 내에서 sectionInsert와 sectionRemoved가 먼저 나오게 정렬
                let sortedOperations = operations.sorted { (op1, op2) in
                    if op1.key == DataChangeType.sectionInsert.notificationName || op1.key == DataChangeType.sectionRemoved.notificationName {
                        return true
                    }
                    if op2.key == DataChangeType.sectionInsert.notificationName || op2.key == DataChangeType.sectionRemoved.notificationName {
                        return false
                    }
                    return op1.indexPaths.first!.row < op2.indexPaths.first!.row
                }
                
                for operation in sortedOperations {
                    result.append(operation)
                }
            }
        }
        return result
    }

    
    
    
    // MARK: - 데이터 리셋
    func resetIndexPaths() {
        self.indexPathTuple.removeAll()
    }
}
