//
//  ListModuleIO.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 17.04.2022.
//

import Foundation

public protocol ListModuleOutput: AnyObject {
    func listModuleWantsToOpenDetails(with id: String)
}
