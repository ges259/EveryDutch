//
//  PlusBtnCoordinating.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit
import Photos
import BSImagePicker


protocol ImagePickerCoordinator: AnyObject {
    
    var nav: UINavigationController { get }
    var imageDelegate: ImagePickerDelegate? { get set }
    
    func presentImagePicker()
    func requestPhotoLibraryAccess(delegate: ImagePickerDelegate?)
}


extension ImagePickerCoordinator {
    func requestPhotoLibraryAccess(delegate: ImagePickerDelegate?) {
        self.imageDelegate = delegate
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized:
            print("Authorized Access")
            self.presentImagePicker()
            
        case .limited:
            print("Limited Access")
            self.presentLimitedLibraryPicker()
            
        case .notDetermined:
            print("notDetermined")
            self.requestPhotoAccess()
            
        case .denied, .restricted:
            print("denied or restricted")
            self.showPhotoLibraryAccessDeniedAlert()
        @unknown default:
            break
        }
    }
    
    private func requestPhotoAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                if newStatus == .authorized || newStatus == .limited {
                    self.presentImagePicker()
                }
            }
        }
    }
    
    private func showPhotoLibraryAccessDeniedAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "Please allow photo library access in settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
            UIApplication.shared.open(settingsUrl, options: [:])
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        nav.present(alert, animated: true, completion: nil)
    }
    
    private func presentLimitedLibraryPicker() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: nav) { _ in
            self.presentImagePicker()
        }
    }
    
    func presentImagePicker() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 1
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        nav.presentImagePicker(imagePicker, select: { (asset) in
            // 선택할 때 처리할 코드
        }, deselect: { (asset) in
            // 선택 해제할 때 처리할 코드
        }, cancel: { (assets) in
            // 취소할 때 처리할 코드
        }, finish: { (assets) in
            // 완료할 때 처리할 코드
            guard let asset = assets.first else { return }
            self.convertAssetToImage(asset: asset)
        })
    }
    
    private func convertAssetToImage(asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { (image, info) in
            guard let selectedImage = image else { return }
            self.imageDelegate?.imageSelected(image: selectedImage)
        }
    }
}




protocol EditScreenCoordProtocol: Coordinator, ImagePickerCoordinator {
    func checkReceiptPanScreen(_ validationDict: [String])
}
