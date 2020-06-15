//
//  BlurhashView.swift
//  Blurhash
//
//  Created by Marc Rousavy on 15.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

class BlurhashCache {
	var blurhash: NSString
	var width: NSNumber
	var height: NSNumber
	var punch: NSNumber
	var image: UIImage
	
	init(blurhash: NSString, width: NSNumber, height: NSNumber, punch: NSNumber, image: UIImage) {
		self.blurhash = blurhash
		self.width = width
		self.height = height
		self.punch = punch
		self.image = image
	}
	
	func isDifferent(blurhash: NSString, width: NSNumber, height: NSNumber, punch: NSNumber) -> Bool {
		return self.blurhash != blurhash || self.width != width || self.height != height || self.punch != punch
	}
}

class BlurhashView: UIView {
	// TODO: Re-render on props change?
	@objc var blurhash: NSString?
	@objc var width: NSNumber?
	@objc var height: NSNumber?
	@objc var punch: NSNumber = 1
	var lastState: BlurhashCache?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}
	
	func decodeImage() -> UIImage? {
		guard let blurhash = self.blurhash, let width = self.width, let height = self.height else {
			return nil
		}
		if (self.lastState?.isDifferent(blurhash: blurhash, width: width, height: height, punch: punch) == false) {
			print("Using cached image from last state!")
			return self.lastState?.image
		}
		print("Re-rendering image!")
		let size = CGSize(width: width.intValue, height: height.intValue)
		let nullableImage = UIImage(blurHash: blurhash as String, size: size, punch: self.punch.floatValue)
		guard let image = nullableImage else {
			return nil
		}
		self.lastState = BlurhashCache(blurhash: blurhash, width: width, height: height, punch: self.punch, image: image)
		return image
	}
	
	func renderBlurhashView() {
		guard let image = self.decodeImage() else {
			return
		}
		DispatchQueue.main.async {
			// image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			self.subviews.forEach({ $0.removeFromSuperview() })
			self.addSubview(UIImageView(image: image))
			print("Set UIImageView's Image source!")
		}
	}
	
	override func didSetProps(_ changedProps: [String]!) {
		self.renderBlurhashView()
	}
}
