//
//  NFTDetailImageCell.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/31.
//

import UIKit
import SnapKit
import SDWebImage

class NFTDetailImageCell: UICollectionViewCell {
    
    var didUpdateImageHeight: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private var heightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            heightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    func populate(with imageUrl: URL) {
        SDWebImageManager.shared.loadImage(with: imageUrl, progress: nil) { [weak self] image, _, error, _, _, _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let image = image {
                    self.imageView.image = image
                    self.updateImageHeightConstraint(size: image.size)
                }
            }
        }
    }
    
    private func updateImageHeightConstraint(size: CGSize) {
        let height = UIScreen.main.bounds.width * size.height / size.width
        imageView.snp.updateConstraints { make in
            heightConstraint = make.height.equalTo(height).constraint
        }
        
        didUpdateImageHeight?()
    }
}

