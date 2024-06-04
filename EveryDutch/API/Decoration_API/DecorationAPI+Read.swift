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
    
    func fetchAllDecorations(
        IDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Decoration?]>, ErrorEnum>) -> Void)
    {
        var decoDictionary = [String: Decoration?]()
        let dictionaryQueue = DispatchQueue(label: "com.yourapp.decoDictionaryQueue", attributes: .concurrent)
        let saveGroup = DispatchGroup()
        
        for id in IDs {
            saveGroup.enter()
            self.fetchDecoration(with: id) { result in
                dictionaryQueue.async(flags: .barrier) {
                    switch result {
                    case .success(let deco):
                        decoDictionary[id] = deco
                    case .failure(_):
                        decoDictionary[id] = nil
                    }
                    saveGroup.leave()
                }
            }
        }
        
        saveGroup.notify(queue: .main) {
            completion(.success(.initialLoad(decoDictionary)))
        }
    }
    
    
    
    
    
    // MARK: - 옵저버 설정
    func observeDecorations(
        IDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Decoration?]>, ErrorEnum>) -> Void)
    {
        for id in IDs {
            let userPath = CARD_DECORATION_REF.child(id)
            
            userPath.observe(.childChanged) { snapshot in
                guard let valueData = snapshot.value as? [String: Any] else {
                    completion(.failure(.readError))
                    return
                }
//                let decoration = Decoration(dictionary: valueData)
                completion(.success(.updated([id: valueData])))
            }
            
            userPath.observe(.childAdded) { snapshot in
                
//                dump(snapshot)
                guard let valueData = snapshot.value as? [String: String] else {
                    completion(.failure(.noMoreData))
                    return
                }
                let decoration = Decoration(dictionary: valueData)
                completion(.success(.added([id: decoration])))
            }
            
            userPath.observe(.childRemoved) { snapshot in
                completion(.success(.removed(id)))
            }
        }
    }
}


/*
 
 */
