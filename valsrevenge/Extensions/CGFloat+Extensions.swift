//
//  CGFloat+Extensions.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/19/21.
//

import CoreGraphics

extension CGFloat {
    func clamped(to r: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.minimum(r.upperBound, CGFloat.maximum(r.lowerBound,self))
    }
}
