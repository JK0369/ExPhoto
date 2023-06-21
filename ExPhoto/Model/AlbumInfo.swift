//
//  AlbumInfo.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/21.
//

import Photos

struct AlbumInfo: Identifiable {
    let id: String?
    let name: String
    let album: PHFetchResult<PHAsset>
    
    init(fetchResult: PHFetchResult<PHAsset>, albumName: String) {
        id = nil
        name = albumName
        album = fetchResult
    }
}
