//
//  IndicatorView.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/31.
//

import UIKit
import AppDevKit

class IndicatorView: UIView {
    private let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        indicator.tintColor = .systemGray
        indicator.backgroundColor = .clear
        indicator.hidesWhenStopped = true
    }
}

extension IndicatorView: ADKInfiniteScrollingViewProtocol {
    func adkInfiniteScrollingStopped(_ scrollView: UIScrollView!) {
        indicator.stopAnimating()
    }
    
    func adkInfiniteScrollingTriggered(_ scrollView: UIScrollView!) {
        indicator.startAnimating()
    }
    
    func adkInfiniteScrollingLoading(_ scrollView: UIScrollView!) {
        // no-op
    }
}
