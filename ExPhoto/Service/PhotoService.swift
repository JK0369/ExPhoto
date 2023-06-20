//
//  PhotoService.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/21.
//

import Photos
import UIKit

protocol PhotoService {
    var authorizationStatus: PHAuthorizationStatus { get }
    var isAuthorizationLimited: Bool { get }
    
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void)
    func goToSetting()
}

extension PhotoService {
    var isAuthorizationLimited: Bool {
        authorizationStatus == .limited
    }
    
    func goToSetting() {
        guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url)
        else { return }
            
        UIApplication.shared.open(url, completionHandler: nil)
    }
}

final class PhotoServiceV1: PhotoService {
    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void) {
        guard authorizationStatus == .notDetermined else {
            completion(authorizationStatus)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
}
