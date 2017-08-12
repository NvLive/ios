//
//  Number+extension.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 28/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import CoreGraphics

extension Bool {
    
    init(_ int: Int) {
        self.init(int > 0 ? true : false)
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * (180.0 / .pi) }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
