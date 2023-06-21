//
//  PhotoCell.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/22.
//

import UIKit
import Then
import Photos

enum SelectionOrder {
    case none
    case selected(Int)
}

struct PhotoCellInfo {
    let phAsset: PHAsset
    let image: UIImage?
    let selectedOrder: SelectionOrder
}

final class PhotoCell: UICollectionViewCell {
    static let id = "PhotoCell"
    
    private let imageView = UIImageView().then {
        $0.isUserInteractionEnabled = false
        $0.contentMode = .scaleAspectFill
    }
    private let highlightedView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2.0
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.layer.borderColor = UIColor.green.cgColor
        $0.isUserInteractionEnabled = false
    }
    private let orderLabel = UILabel().then {
        $0.textColor = .green
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
        imageView.addSubview(highlightedView)
        highlightedView.addSubview(orderLabel)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        highlightedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        orderLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(4)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare(info: nil)
    }
    
    func prepare(info: PhotoCellInfo?) {
        imageView.image = info?.image
        
        if case let .selected(order) = info?.selectedOrder {
            highlightedView.isHidden = false
            orderLabel.text = String(order)
        } else {
            highlightedView.isHidden = true
        }
    }
}
