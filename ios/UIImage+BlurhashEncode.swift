//
//  BlurhashEncode.swift
//  Blurhash
//
//  Created by Marc Rousavy on 04.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	public func encodeBlurhash(numberOfComponents components: (Int, Int)) -> String? {
		let pixelWidth = Int(round(size.width * scale))
		let pixelHeight = Int(round(size.height * scale))

		let context = CGContext(
			data: nil,
			width: pixelWidth,
			height: pixelHeight,
			bitsPerComponent: 8,
			bytesPerRow: pixelWidth * 4,
			space: CGColorSpace(name: CGColorSpace.sRGB)!,
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		)!
		context.scaleBy(x: scale, y: -scale)
		context.translateBy(x: 0, y: -size.height)

		UIGraphicsPushContext(context)
		draw(at: .zero)
		UIGraphicsPopContext()

		guard let cgImage = context.makeImage(),
			let dataProvider = cgImage.dataProvider,
			let data = dataProvider.data,
			let pixels = CFDataGetBytePtr(data)
		else {
			assertionFailure("Unexpected error!")
			return nil
		}

		let width = cgImage.width
		let height = cgImage.height
		let bytesPerRow = cgImage.bytesPerRow

		var factors: [(Float, Float, Float)] = []
		for y in 0 ..< components.1 {
			for x in 0 ..< components.0 {
				let normalisation: Float = (x == 0 && y == 0) ? 1 : 2
				let factor = multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
					normalisation * cos(Float.pi * Float(x) * $0 / Float(width)) as Float * cos(Float.pi * Float(y) * $1 / Float(height)) as Float
				}
				factors.append(factor)
			}
		}

		let dc = factors.first!
		let ac = factors.dropFirst()

		var hash = ""

		let sizeFlag = (components.0 - 1) + (components.1 - 1) * 9
		hash += sizeFlag.encode83(length: 1)

		let maximumValue: Float
		if ac.count > 0 {
			let actualMaximumValue = ac.map { max(abs($0.0), abs($0.1), abs($0.2)) }.max()!
			let quantisedMaximumValue = Int(max(0, min(82, floor(actualMaximumValue * 166 - 0.5))))
			maximumValue = Float(quantisedMaximumValue + 1) / 166
			hash += quantisedMaximumValue.encode83(length: 1)
		} else {
			maximumValue = 1
			hash += 0.encode83(length: 1)
		}

		hash += encodeDC(dc).encode83(length: 4)

		for factor in ac {
			hash += encodeAC(factor, maximumValue: maximumValue).encode83(length: 2)
		}

		return hash
	}

	private final func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, pixelOffset: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
		var r: Float = 0
		var g: Float = 0
		var b: Float = 0

		let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

		for x in 0 ..< width {
			for y in 0 ..< height {
				let basis = basisFunction(Float(x), Float(y))
				r += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow])
				g += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow])
				b += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
			}
		}

		let scale = 1 / Float(width * height)

		return (r * scale, g * scale, b * scale)
	}
}
