//
//  EditScreenAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/6/24.
//

import Foundation
import FirebaseDatabaseInternal

protocol EditScreenAPIType: DecorationAPIType {
    func createData(dict: [String: Any]) async throws -> String
    
    func updateData(IdRef: String, dict: [String: Any]) async throws
    
    func fetchData(dataRequiredWhenInEidtMode: String?) async throws -> EditProviderModel
}


extension EditScreenAPIType {
    

    func validatePersonalID(personalID: String) async throws -> Bool {
        // Firebase Database의 참조 생성 및 쿼리 구성
        // personal_ID 필드의 값이 personalID와 일치하는 항목을 쿼리
        let query = USER_REF
            .queryOrdered(byChild: DatabaseConstants.personal_ID)
            .queryEqual(toValue: personalID)
        
        // 비동기 작업
        return try await withCheckedThrowingContinuation { continuation in
            // 쿼리 결과를 한 번만 관찰하여 데이터 스냅샷을 가져옴
            query.observeSingleEvent(of: .value) { snapshot in
                // 스냅샷이 존재하지 않는 경우, false 반환
                guard snapshot.exists() else {
                    continuation.resume(returning: false)
                    return
                }
                
                // 스냅샷의 첫 번째 자식 노드를 확인
                if let firstChild = snapshot.children.allObjects.first as? DataSnapshot,
                   let userDict = firstChild.value as? [String: Any],
                   let id = userDict["personal_ID"] as? String,
                   id == personalID
                {
                    // 첫 번째 자식 노드가 존재하고, 해당 personal_ID가 요청한 값과 일치하면 true 반환
                    continuation.resume(returning: true)
                } else {
                    // 첫 번째 자식 노드가 존재하지 않거나, personal_ID가 요청한 값과 일치하지 않으면 false 반환
                    continuation.resume(returning: false)
                }
            } withCancel: { error in
                // 쿼리가 취소되거나 오류가 발생하면 continuation을 에러와 함께 재개
                continuation.resume(throwing: error)
            }
        }
    }
}
