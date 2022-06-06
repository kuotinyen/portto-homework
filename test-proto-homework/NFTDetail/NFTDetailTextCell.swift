//
//  NFTDetailTextCell.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/6/1.
//

import UIKit
import SnapKit

class NFTDetailTextCell: UICollectionViewCell {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
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
        
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    func populate(with text: String) {
        textLabel.text = text
    }
}

