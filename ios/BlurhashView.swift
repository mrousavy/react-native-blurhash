//
//  BlurhashView.swift
//  Blurhash
//
//  Created by Marc Rousavy on 15.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

let LOG_ID = "BlurhashView"

class BlurhashCache {
	var blurhash: String
	var decodeWidth: Int
	var decodeHeight: Int
	var decodePunch: Float
	var image: UIImage
	
	init(blurhash: String, decodeWidth: Int, decodeHeight: Int, decodePunch: Float, image: UIImage) {
		self.blurhash = blurhash
		self.decodeWidth = decodeWidth
		self.decodeHeight = decodeHeight
		self.decodePunch = decodePunch
		self.image = image
	}
	
	init(blurhash: NSString, decodeWidth: NSNumber, decodeHeight: NSNumber, decodePunch: NSNumber, image: UIImage) {
		self.blurhash = blurhash as String
		self.decodeWidth = decodeWidth.intValue
		self.decodeHeight = decodeHeight.intValue
		self.decodePunch = decodePunch.floatValue
		self.image = image
	}
	
	func isDifferent(blurhash: NSString, decodeWidth: NSNumber, decodeHeight: NSNumber, decodePunch: NSNumber) -> Bool {
		return self.blurhash != blurhash as String || self.decodeWidth != decodeWidth.intValue || self.decodeHeight != decodeHeight.intValue || self.decodePunch != decodePunch.floatValue
	}
}

class BlurhashView: UIView {
	@objc var blurhash: NSString?
	@objc var decodeWidth: NSNumber = 32
	@objc var decodeHeight: NSNumber = 32
	@objc var decodePunch: NSNumber = 1
	var lastState: BlurhashCache?
	let imageContainer: UIImageView
	
	override init(frame: CGRect) {
		self.imageContainer = UIImageView()
		self.imageContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		super.init(frame: frame)
		self.addSubview(self.imageContainer)
	}
	
	required init?(coder aDecoder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}
	
	func decodeImage() -> UIImage? {
		guard let blurhash = self.blurhash else {
			return nil
		}
		if (self.lastState?.isDifferent(blurhash: blurhash, decodeWidth: decodeWidth, decodeHeight: decodeHeight, decodePunch: self.decodePunch) == false) {
			print("\(LOG_ID): Using cached image from last state!")
			return self.lastState?.image
		}
		print("\(LOG_ID): Re-rendering image on \(Thread.isMainThread ? "main" : "separate") thread!")
		let size = CGSize(width: decodeWidth.intValue, height: decodeHeight.intValue)
		let start = DispatchTime.now()
		let nullableImage = UIImage(blurHash: blurhash as String, size: size, punch: self.decodePunch.floatValue)
		let end = DispatchTime.now()
		print("\(LOG_ID): Image decoding took: \((end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000) milliseconds")
		guard let image = nullableImage else {
			return nil
		}
		self.lastState = BlurhashCache(blurhash: blurhash, decodeWidth: decodeWidth, decodeHeight: decodeHeight, decodePunch: self.decodePunch, image: image)
		return image
	}
	
	func renderBlurhashView() {
		// TODO: background thread decoding?
		guard let image = self.decodeImage() else {
			return
		}

		self.imageContainer.image = image
		print("\(LOG_ID): Set UIImageView's Image source!")
	}
	
	override func didSetProps(_ changedProps: [String]!) {
		self.renderBlurhashView()
	}
}
