//
//  Blurhash.swift
//  Blurhash
//
//  Created by Marc Rousavy on 08.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

@objc(Blurhash)
class Blurhash: RCTViewManager {
	var blurhash: String? = nil
	var width: Int = 300
	var height: Int = 300
	
	override func view() -> UIView? {
		guard let blurhash = self.blurhash else {
			guard let image = UIImage(color: .black) else {
				return nil
			}
			return UIImageView(image: image)
		}
		let image = UIImage(blurHash: blurhash, size: CGSize(width: self.width, height: self.height))
		return UIImageView(image: image)
	}
	
	@objc(blurhash:)
	func setBlurhash(blurhash: String) {
		self.blurhash = blurhash
	}
	
	@objc(height:)
	func setHeight(height: Int) {
		self.height = height
	}
	
	@objc(width:)
	func setWidth(width: Int) {
		self.width = width
	}
}
