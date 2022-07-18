//
//  Items.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 18.07.2022.
//

import Foundation

struct TitleItem: Hashable, Identifiable {
    let id = UUID()

    let value: String
}

struct DetailsItem: Hashable, Identifiable {
    let id = UUID()
    
    let value: String
}

struct ImageItem: Hashable, Identifiable {
    let id = UUID()
    
    let value: URL
}
