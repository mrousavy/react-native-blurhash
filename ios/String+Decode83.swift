//
//  BlurhashHelper.swift
//  Blurhash
//
//  Created by Marc Rousavy on 10.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

extension String {
	func decode83() -> Int {
		var value: Int = 0
		for character in self {
			if let digit = decodeCharacters[String(character)] {
				value = value * 83 + digit
			}
		}
		return value
	}
}
