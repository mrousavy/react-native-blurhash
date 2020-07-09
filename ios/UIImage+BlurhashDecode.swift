//
//  BlurhashDecode.swift
//  Blurhash
//
//  Created by Marc Rousavy on 08.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public convenience init?(blurHash: String, size: CGSize, punch: Float = 1) {
        guard blurHash.count >= 6 else { return nil }

		let sizeFlag = String(blurHash[0]).decode83()
		let numY = (sizeFlag / 9) + 1
		let numX = (sizeFlag % 9) + 1

		let quantisedMaximumValue = String(blurHash[1]).decode83()
        let maximumValue = Float(quantisedMaximumValue + 1) / 166

        guard blurHash.count == 4 + 2 * numX * numY else { return nil }

        let colours: [(Float, Float, Float)] = (0 ..< numX * numY).map { i in
            if i == 0 {
				let value = String(blurHash[2 ..< 6]).decode83()
                return decodeDC(value)
            } else {
                let value = String(blurHash[4 + i * 2 ..< 4 + i * 2 + 2]).decode83()
                return decodeAC(value, maximumValue: maximumValue * punch)
            }
        }

        let width = Int(size.width)
        let height = Int(size.height)
        let bytesPerRow = width * 3
        guard let data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height) else { return nil }
        CFDataSetLength(data, bytesPerRow * height)
        guard let pixels = CFDataGetMutableBytePtr(data) else { return nil }

        for y in 0 ..< height {
            for x in 0 ..< width {
                var r: Float = 0
                var g: Float = 0
                var b: Float = 0

                for j in 0 ..< numY {
                    for i in 0 ..< numX {
                        let basis = cos(Float.pi * Float(x) * Float(i) / Float(width)) * cos(Float.pi * Float(y) * Float(j) / Float(height))
                        let colour = colours[i + j * numX]
                        r += colour.0 * basis
                        g += colour.1 * basis
                        b += colour.2 * basis
                    }
                }

                let intR = UInt8(linearTosRGB(r))
                let intG = UInt8(linearTosRGB(g))
                let intB = UInt8(linearTosRGB(b))

                pixels[3 * x + 0 + y * bytesPerRow] = intR
                pixels[3 * x + 1 + y * bytesPerRow] = intG
                pixels[3 * x + 2 + y * bytesPerRow] = intB
            }
        }

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        guard let provider = CGDataProvider(data: data) else { return nil }
        guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: bytesPerRow,
        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { return nil }

        self.init(cgImage: cgImage)
    }
}
