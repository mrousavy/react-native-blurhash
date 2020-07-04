//
//  ReactLogger.swift
//  Blurhash
//
//  Created by Marc Rousavy on 04.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

let context = "RNBlurhash"

func log(level: RCTLogLevel, message: String, file: String = #file, lineNumber: Int = #line) {
	RCTDefaultLogFunction(level, RCTLogSource.native, file, lineNumber as NSNumber, "\(context): \(message)")
}
