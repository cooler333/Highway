//
//  Mockable.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Coolerov on 12.05.2022.
//

import Foundation
import List
import Domain

@testable import InfiniteScroll

// sourcery:begin: AutoMockable

extension ListRepositoryProtocol {}
extension ToastNotificationManagerProtocol {}
extension ListModuleOutput {}

// sourcery:end
