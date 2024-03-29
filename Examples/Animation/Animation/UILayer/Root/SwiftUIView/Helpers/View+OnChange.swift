//
//  View+OnChange.swift
//  Animation
//
//  Created by Dmitrii Coolerov on 01.08.2022.
//

import Combine
import SwiftUI

extension View {
    /// A backwards compatible wrapper for iOS 14 `onChange`
    @ViewBuilder func onChangeWrapper<T: Equatable>(value: T, perform: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            onChange(of: value, perform: perform)
        } else {
            onReceive(Just(value)) { value in
                perform(value)
            }
        }
    }
}
