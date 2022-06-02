//
//  NFTDetailModels.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/6/2.
//

import Foundation

enum NFTDetailSection: Int, Hashable, CaseIterable {
    case image
    case name
    case description
}

enum NFTDetailItemType: Hashable {
    case image(URL)
    case text(String)
}

class NFTDetailItem: Hashable {
    let itemType: NFTDetailItemType
    
    init(itemType: NFTDetailItemType) {
        self.itemType = itemType
    }
    
    static func == (lhs: NFTDetailItem, rhs: NFTDetailItem) -> Bool {
        lhs.itemType == rhs.itemType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemType)
    }
}
