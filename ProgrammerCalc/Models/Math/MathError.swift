//
//  MathError.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 15.11.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

enum MathError: Error, CaseIterable {
    case divByZero
}

extension MathError: LocalizedError {
    public var localizedDescription: String? {
        switch self {
        case .divByZero:
            return NSLocalizedString("Cannot divide by zero", comment: "")
        }
    }
}
