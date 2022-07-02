//
//  InfiniteScrollModuleIO.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 17.04.2022.
//

import Foundation

protocol InfiniteScrollModuleOutput: AnyObject {
    func infiniteScrollModuleWantsToOpenDetails(with id: String)
}
