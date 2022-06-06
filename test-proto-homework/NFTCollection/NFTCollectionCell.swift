//
//  NFTCollectionCell.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/20.
//

import UIKit
import SnapKit
import SDWebImage

class NFTCollectionCell: UICollectionViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.directionalLayoutMargins = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, imageView])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    func populate(with item: NFTCollectionItem) {
        nameLabel.text = item.nft?.name
        SDWebImageManager.shared.loadImage(with: item.nft?.imageUrl, progress: nil) { image, _, error, _, _, _ in
            self.imageView.image = image
        }
    }
}
