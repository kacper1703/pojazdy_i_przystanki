//
//  Iterable.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 14/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

protocol Iterable: Hashable {}

extension Iterable {

    static func cases() -> AnySequence<Self> {
        // swiftlint:disable type_name
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee} }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
