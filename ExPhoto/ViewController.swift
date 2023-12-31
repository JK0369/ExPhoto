//
//  ViewController.swift
//  ExPhoto
//
//  Created by 김종권 on 2023/06/21.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    private let button = UIButton(type: .system).then {
        $0.setTitle("앨범 열기", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitleColor(.systemBlue, for: [.normal, .highlighted])
        $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private let authService: PhotoAuthService = MyPhotoAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func didTapButton() {
        authService.requestAuthorization { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let vc = PhotoViewController().then {
                    $0.modalPresentationStyle = .fullScreen
                }
                present(vc, animated: true)
            case .failure:
                return
            }
        }
    }
}
