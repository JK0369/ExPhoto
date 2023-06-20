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
    
    func requestAuthorization()
}

extension PhotoService {
    var isAuthorizationLimited: Bool {
        authorizationStatus == .limited
    }
}
