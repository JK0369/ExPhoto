//
//  PhotoCell.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/22.
//

import UIKit
import Then

final class PhotoCell: UICollectionViewCell {
    static let id = "PhotoCell"
    
    private let imageView = UIImageView().then {
        $0.isUserInteractionEnabled = false
        $0.contentMode = .scaleAspectFill
    }
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true // 주의: 이값을 안주면 이미지가 셀의 다른 영역을 침범하는 영향을 주는것
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare(image: nil)
    }
    
    func prepare(image: UIImage?) {
        imageView.image = image
    }
}
