//
//  DecorationAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/30/24.
//

import UIKit
import FirebaseStorage

protocol DecorationAPI {}

extension DecorationAPI {
    // MARK: - 데코레이션 가져오기
    func fetchDecoration(dataRequiredWhenInEditMode: String?) async throws -> Decoration? {
        guard let dataRequiredWhenInEidtMode = dataRequiredWhenInEditMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Decoration?, Error>) in
            self.fetchDecoration(with: dataRequiredWhenInEidtMode) { result in
                switch result {
                case .success(let deco):
                    continuation.resume(returning: deco)
                case .failure(_):
                    continuation.resume(throwing: ErrorEnum.readError)
                }
            }
        }
    }

    private func fetchDecoration(
        with id: String,
        completion: @escaping (Result<Decoration?, ErrorEnum>) -> Void)
    {
        CARD_DECORATION_REF
            .child(id)
            .observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists() else {
                    completion(.success(nil))
                    return
                }
                guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(.readError))
                    return
                }
                let decoration = Decoration(dictionary: value)
                completion(.success(decoration))
            }
    }
    
    
    
    
    // MARK: - 옵저버 설정
    func observeDecorations(
        IDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Decoration?]>, ErrorEnum>) -> Void)
    {
        for id in IDs {
            let userPath = CARD_DECORATION_REF.child(id)
            
            // 전체 데이터를 가져오는 .value 이벤트
            userPath.observe(.value) { snapshot in
                
                if snapshot.exists() {
                    guard let valueData = snapshot.value as? [String: Any] else {
                        print("Failed to parse snapshot value as dictionary for ID: \(id)")
                        completion(.failure(.readError))
                        return
                    }
                    let decoration = Decoration(dictionary: valueData)
                    completion(.success(.added([id: decoration])))
                } else {
                    // 스냅샷이 존재하지 않으면 데이터가 삭제된 것으로 간주
//                    completion(.success(.removed(id)))
                }
            }
            
            // 데이터가 삭제될 때를 감지하는 .childRemoved 이벤트
            userPath.observe(.childRemoved) { snapshot in
                completion(.success(.removed(id)))
            }
        }
    }
}
