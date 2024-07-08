//
//  EditScreenAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/6/24.
//

import Foundation
import FirebaseDatabaseInternal

protocol EditScreenAPIType: DecorationAPI {
    func createData(dict: [String: Any]) async throws -> String
    
    func updateData(IdRef: String, dict: [String: Any]) async throws
    
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
}


extension EditScreenAPIType {
    
    func validatePersonalID(
        userID: String,
        personalID: String
    ) async throws -> Bool {
        // Firebase Database의 참조 생성 및 쿼리 구성
        let query = USER_REF
            .queryOrdered(byChild: DatabaseConstants.personal_ID)
            .queryEqual(toValue: personalID)
        
        // 비동기 작업
        return try await withCheckedThrowingContinuation { continuation in
            // 쿼리 결과를 한 번만 관찰하여 데이터 스냅샷을 가져옴
            query.observeSingleEvent(of: .value) { snapshot in
                do {
                    let isDuplicate = try self.processSnapshot(snapshot: snapshot, userID: userID, personalID: personalID)
                    continuation.resume(returning: isDuplicate)
                } catch {
                    continuation.resume(throwing: error)
                }
            } withCancel: { error in
                // 쿼리가 취소되거나 오류가 발생하면 continuation을 에러와 함께 재개
                continuation.resume(throwing: error)
            }
        }
    }

    private func processSnapshot(snapshot: DataSnapshot, userID: String, personalID: String) throws -> Bool {
        // 스냅샷이 존재하지 않는 경우, true 반환
        guard snapshot.exists() else {
            return true
        }
        
        
        
        // 스냅샷의 첫 번째 자식 노드를 확인
        if let firstChild = snapshot.children.allObjects.first as? DataSnapshot,
           let userDict = firstChild.value as? [String: Any],
           let id = userDict[DatabaseConstants.personal_ID] as? String,
           id == personalID {
            // personal_ID가 요청한 값과 일치하는 경우
            let fetchedUserID = firstChild.key
            if fetchedUserID == userID {
                // personal_ID가 중복이지만 해당 userID와 동일한 경우
                return true
            } else {
                // personal_ID가 중복되고 다른 userID인 경우
                return false
            }
        } else {
            // 해당하는 노드가 없는 경우
            return false
        }
    }
}
