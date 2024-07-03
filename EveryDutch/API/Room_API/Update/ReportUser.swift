//
//  ReportUser.swift
//  EveryDutch
//
//  Created by 계은성 on 6/20/24.
//

import Foundation
import FirebaseDatabaseInternal
import FirebaseAuth

extension RoomsAPI {
    
    /// 사용자를 신고하는 메서드
    /// - Parameters:
    ///   - roomID: 방의 ID
    ///   - reportedUserID: 신고당한 사용자의 ID
    ///   - completion: 신고 결과를 처리하는 클로저
    func reportUser(
        roomID: String,
        reportedUserID: String,
        completion: @escaping (Result<Int, ErrorEnum>) -> Void
    ) {
        // 현재 로그인한 사용자의 ID를 가져옴
        guard let reporterID: String = self.getMyUserID else {
            completion(.failure(.readError))
            return
        }
        
        let reportedUserRef = ROOM_USERS_REF
            .child(roomID)
            .child(reportedUserID)
        
        // 트랜잭션 블록을 사용하여 데이터베이스를 업데이트
        reportedUserRef.runTransactionBlock({ currentData in
            var user = currentData.value as? [String: Any] ?? [:]
            var reportCount = user[DatabaseConstants.reportCount] as? Int ?? 0
            var reportedBy = user[DatabaseConstants.reportedBy] as? [String: Bool] ?? [:]
            
            // 이미 신고한 경우 트랜잭션을 중단
            if reportedBy[reporterID] == true {
                return TransactionResult.abort()
            }
            
            // 신고 처리
            reportCount += 1
            reportedBy[reporterID] = true
            
            // 업데이트된 값을 데이터베이스에 저장
            user[DatabaseConstants.reportCount] = reportCount
            user[DatabaseConstants.reportedBy] = reportedBy
            currentData.value = user
            
            return TransactionResult.success(withValue: currentData)
            
        }) { [weak self] error, committed, snapshot in
            // 트랜잭션 완료 후 처리
            self?.handleTransactionCompletion(
                error: error,
                committed: committed,
                snapshot: snapshot,
                completion: completion)
        }
    }
    
    /// 트랜잭션 완료 후 결과를 처리하는 메서드
    /// - Parameters:
    ///   - error: 에러 객체
    ///   - committed: 트랜잭션 커밋 여부
    ///   - snapshot: 트랜잭션 후의 데이터 스냅샷
    ///   - completion: 신고 결과를 처리하는 클로저
    private func handleTransactionCompletion(
        error: Error?,
        committed: Bool,
        snapshot: DataSnapshot?,
        completion: @escaping (Result<Int, ErrorEnum>) -> Void
    ) {
        if let _ = error {
            // 에러가 발생한 경우
            completion(.failure(.readError))
        } else if !committed {
            // 트랜잭션이 커밋되지 않은 경우
            completion(.failure(.alreadyReported))
        } else if let user = snapshot?.value as? [String: Any], 
                  let reportCount = user[DatabaseConstants.reportCount] as? Int {
            // 트랜잭션이 성공적으로 커밋된 경우 신고 횟수 반환
            completion(.success(reportCount))
        } else {
            // 예상치 못한 데이터 상태인 경우
            completion(.failure(.unknownError))
        }
    }
}
