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
    
    func requestAuthorization()
}
