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
    private var indexPaths: [String: [IndexPath]] = [:]
    private var error: ErrorEnum?
    
    
    
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
        print("_________________________________")
        print(#function)
        print(" ----- ----- \(self.error)  ----- ----- ")
        print("_________________________________")
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
        let notiName = eventType.notificationName
        
        if self.indexPaths[notiName] == nil {
            self.indexPaths[notiName] = []
        }
        
        for indexPath in indexPaths {
            if let existingIndexPaths = self.indexPaths[notiName],
                !existingIndexPaths.contains(indexPath)
            {
                self.indexPaths[notiName]?.append(indexPath)
            }
        }
    }
    /// 디바운스를 설정하는 메서드
    private func debounce() {
        // 일정 시간이 지난 후, 동작할 행동 설정
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            print(#function)
            self.postNotification()
        }
        // 행동 저장
        self.workItem = newWorkItem
        // 디바운스 설정
        self.queue.asyncAfter(deadline: .now() + self.interval, execute: newWorkItem)
    }
    
    // MARK: - 에러 디바운스
    /// 인덱스패스를 삭제후, 디바운스를 통해 에러를 post하도록 설정하는 메서드
    func triggerErrorDebounce(_ errorType: ErrorEnum) {
        // 디바운스 취소
        self.cancelScheduledWork()
        // 에러 설정
        self.error = errorType
        // 업데이트하지 않음
        self.indexPaths = [:]
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
    /// 노티피케이션에 post할 딕셔너리를 리턴,
    /// 에러가 있다면 ["error" : ErrorEnum]
    /// 에러가 없다면 [String : [IndexPath]]
    private var getUserInfoData: [String: Any] {
        return self.error != nil
            ? [DataChangeType.error.notificationName: self.error ?? .unknownError]
            : self.indexPaths
    }
    
    // MARK: - 데이터 초기화
    /// 디바운스 취소, 인덱스패스 및 에러 데이터 초기화
    func reset() {
        self.cancelScheduledWork()
        self.indexPaths = [:]
        self.error = nil
    }
    private func cancelScheduledWork() {
        self.workItem?.cancel()
    }
}
