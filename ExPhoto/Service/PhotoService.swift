//
//  PhotoService.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/22.
//

import UIKit
import Photos
import Then

/*
 Photos 프레임워크
 - PHAsset: 사진 라이브러리에 있는 이미지, 비디오와 같은 하나의 애셋을 의미
 - PHAssetCollection: PHAsset의 컬렉션
 - PHCachingImageManager: 요청한 크기에 맞게 이미지를 로드하여 캐싱까지 수행
 - PHFetchResult: 앨범 하나
 
 Album(PHFetchResult) 먼저 불러오기
  > Album에 담긴 PHAsset을 가져와, 이미지 or 비디오 획득 (PHAsset)
 */

protocol PhotoService {
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void)
    func fetchImage(phAsset: PHAsset, size: CGSize, contentMode: PHImageContentMode, completion: @escaping (UIImage) -> Void)
}

final class MyPhotoService: NSObject, PhotoService {
    private let imageManager = PHCachingImageManager()
    weak var delegate: PHPhotoLibraryChangeObserver?
    
    override init() {
        super.init()
        // PHPhotoLibraryChangeObserver 델리게이트
        // PHPhotoLibrary: 변경사항을 알려 데이터 리프레시에 사용
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void) {
        var phAssets = [PHAsset]()
        defer { completion(phAssets) }
        
        guard 0 < album.count else { return }
        album.enumerateObjects { asset, index, stopPointer in
            guard index <= album.count - 1 else {
                stopPointer.pointee = true
                return
            }
            phAssets.append(asset)
        }
    }
    
    func fetchImage(
        phAsset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode,
        completion: @escaping (UIImage) -> Void
    ) {
        let options = PHImageRequestOptions().then {
            $0.isNetworkAccessAllowed = true // iCloud
            $0.deliveryMode = .highQualityFormat
        }
        
        imageManager.requestImage(
            for: phAsset,
            targetSize: size,
            contentMode: contentMode,
            options: options,
            resultHandler: { image, _ in
                guard let image else { return }
                completion(image)
            }
        )
    }
}

extension MyPhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
}
