//
//  MediaType.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/21.
//

enum MediaType {
    case all
    case image
    case video
    
    var title: String {
        switch self {
        case .all:
            return "이미지와 비디오"
        case .image:
            return "이미지"
        case .video:
            return "비디오"
        }
    }
}
