//
//  Mockable.swift
//  InfiniteScrollTests
//
//  Created by Dmitrii Coolerov on 12.05.2022.
//

import Domain
import Foundation
import List

@testable import InfiniteScroll

// sourcery:begin: AutoMockable

extension ListRepositoryProtocol {}
extension ToastNotificationManagerProtocol {}
extension ListModuleOutput {}

// sourcery:end
