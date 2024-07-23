//
//  BottomStackItem.swift
//  CustomTabBar
//
//  Created by 远路蒋 on 2024/7/23.
//

import Foundation

class BottomStackItem {
    var title: String
    var image: String
    var isSelected: Bool
    
    init(title: String, image: String, isSelected: Bool = false) {
        self.title = title
        self.image = image
        self.isSelected = isSelected
    }
}
