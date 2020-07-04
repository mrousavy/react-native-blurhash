//
//  UIImage+Base64.swift
//  Blurhash
//
//  Created by Marc Rousavy on 04.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	public convenience init?(base64: String) {
		guard let firstComma = base64.firstIndex(of: ",") else {
			return nil
		}
		let firstIndex = base64.index(after: firstComma)
		let formattedBase64 = String(base64[firstIndex...])
		guard let imageData = Data(base64Encoded: formattedBase64, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) else {
			return nil
		}
		self.init(data: imageData)
	}
}
