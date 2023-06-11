//
//  Storable.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol Storable: Codable {
    associatedtype ReturnType: Storable
    static var storageKey: String { get }
    static func getDefault() -> ReturnType
    func set(_ data: ReturnType)
}
