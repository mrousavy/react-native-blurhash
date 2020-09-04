//
//  BlurhashError.swift
//  Blurhash
//
//  Created by Marc Rousavy on 04.09.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

enum BlurhashError: Error {
	case invalidBlurhashString(isNil: Bool)
	case invalidBlurhashDecodeWidth(actualValue: Int)
	case invalidBlurhashDecodeHeight(actualValue: Int)
	case invalidBlurhashDecodePunch(actualValue: Float)
	case decodeError(message: String?)
}
