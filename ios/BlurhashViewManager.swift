//
//  BlurhashViewManager.swift
//  Blurhash
//
//  Created by Marc Rousavy on 08.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

@objc(BlurhashViewManager)
class BlurhashViewManager: RCTViewManager {
	var blurhash: String? = nil
	var width: Int = 300
	var height: Int = 300
	
	override func view() -> UIView? {
		let image = UIImage(blurHash: "LEHV6nWB2yk8pyo0adR*.7kCMdnj", size: CGSize(width: 400, height: 300))
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
	
	override static func requiresMainQueueSetup() -> Bool {
	  return true
	}
}
