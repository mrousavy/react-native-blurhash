//
//  BinaryInteger+Encode83.swift
//  Blurhash
//
//  Created by Marc Rousavy on 10.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

extension BinaryInteger {
	func encode83(length: Int) -> String {
		var result = ""
		for i in 1 ... length {
			let digit = (Int(self) / pow(83, length - i)) % 83
			result += encodeCharacters[Int(digit)]
		}
		return result
	}
}

private func pow(_ base: Int, _ exponent: Int) -> Int {
	return (0 ..< exponent).reduce(1) { value, _ in value * base }
}
