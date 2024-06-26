//
//  DecorationAPI+Image.swift
//  EveryDutch
//
//  Created by 계은성 on 6/2/24.
//

import UIKit
import FirebaseStorage

extension DecorationAPI {
    
    // MARK: - 이미지 저장
    func uploadImage(data: [String: UIImage]) async throws -> [String: String] {
        var urlDict = [String: String]()
        for (key, image) in data {
            let uploadURL = try await self.uploadImageAndGetURL(key: key, image: image)
            urlDict[key] = uploadURL
        }
        return urlDict
    }
    
    private func uploadImageAndGetURL(key: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to convert UIImage to JPEG data"])
        }
        let storageRef = Storage.storage().reference().child("images/\(key).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<String, Error>) in
            
            let uploadTask = storageRef.putData(imageData, metadata: metadata)
            uploadTask.observe(.success) { snapshot in
                storageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let url = url {
                        continuation.resume(returning: url.absoluteString)
                    }
                }
            }
            
            uploadTask.observe(.failure) { snapshot in
                if let error = snapshot.error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
    
