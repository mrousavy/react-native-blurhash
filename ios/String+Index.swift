//
//  String+Index.swift
//  Blurhash
//
//  Created by Marc Rousavy on 04.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

extension StringProtocol {
	func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
	func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension Collection {
	func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
	func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

extension String {
	subscript(offset: Int) -> Character {
		return self[index(startIndex, offsetBy: offset)]
	}

	subscript(bounds: CountableClosedRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start ... end]
	}

	subscript(bounds: CountableRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start ..< end]
	}
}
