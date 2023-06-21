//
//  AlbumService.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/21.
//

import Photos
import UIKit
import Then

protocol AlbumService {
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void)
}

final class MyAlbumService: AlbumService {
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
        // 0. albums 변수 선언
        var albums = [AlbumInfo]()
        defer { completion(albums) }
        
        // 1. query 설정
        let fetchOptions = PHFetchOptions().then {
            $0.predicate = getPredicate(mediaType: mediaType)
            $0.sortDescriptors = getSortDescriptors
        }
        
        // 2. standard 앨범을 query로 이미지 가져오기
        let standardFetchResult = PHAsset.fetchAssets(with: fetchOptions)
        albums.append(.init(fetchResult: standardFetchResult, albumName: mediaType.title))
        
        // 3. smart 앨범을 query로 이미지 가져오기
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: PHFetchOptions()
        )
        smartAlbums.enumerateObjects { [weak self] phAssetCollection, index, pointer in
            guard let self, index <= smartAlbums.count - 1 else {
                pointer.pointee = true
                return
            }
            
            // 값을 빠르게 받아오지 못하는 경우
            if phAssetCollection.estimatedAssetCount == NSNotFound {
                // 쿼리를 날려서 가져오기
                let fetchOptions = PHFetchOptions().then {
                    $0.predicate = self.getPredicate(mediaType: mediaType)
                    $0.sortDescriptors = self.getSortDescriptors
                }
                let fetchResult = PHAsset.fetchAssets(in: phAssetCollection, options: fetchOptions)
                albums.append(.init(fetchResult: fetchResult, albumName: mediaType.title))
            }
        }
    }
    
    private func getPredicate(mediaType: MediaType) -> NSPredicate {
        let format = "mediaType == %d"
        switch mediaType {
        case .all:
            return .init(
                format: format + " || " + format,
                PHAssetMediaType.image.rawValue,
                PHAssetMediaType.video.rawValue
            )
        case .image:
            return .init(
                format: format,
                PHAssetMediaType.image.rawValue
            )
        case .video:
            return .init(
                format: format,
                PHAssetMediaType.video.rawValue
            )
        }
    }
    
    private let getSortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false),
        NSSortDescriptor(key: "modificationDate", ascending: false)
    ]
}
