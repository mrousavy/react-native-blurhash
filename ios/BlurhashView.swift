//
//  BlurhashView.swift
//  Blurhash
//
//  Created by Marc Rousavy on 15.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

final class BlurhashCache {
	var blurhash: String?
	var decodeWidth: Int
	var decodeHeight: Int
	var decodePunch: Float

	init(blurhash: String?, decodeWidth: Int, decodeHeight: Int, decodePunch: Float) {
		self.blurhash = blurhash
		self.decodeWidth = decodeWidth
		self.decodeHeight = decodeHeight
		self.decodePunch = decodePunch
	}

	init(blurhash: NSString?, decodeWidth: NSNumber, decodeHeight: NSNumber, decodePunch: NSNumber) {
		self.blurhash = blurhash as String?
		self.decodeWidth = decodeWidth.intValue
		self.decodeHeight = decodeHeight.intValue
		self.decodePunch = decodePunch.floatValue
	}

	final func isDifferent(blurhash: NSString, decodeWidth: NSNumber, decodeHeight: NSNumber, decodePunch: NSNumber) -> Bool {
		return self.blurhash != blurhash as String || self.decodeWidth != decodeWidth.intValue || self.decodeHeight != decodeHeight.intValue || self.decodePunch != decodePunch.floatValue
	}
}

final class BlurhashView: UIView {
	@objc var blurhash: NSString?
	@objc var decodeWidth: NSNumber = 32
	@objc var decodeHeight: NSNumber = 32
	@objc var decodePunch: NSNumber = 1
	@objc var resizeMode: NSString = "cover"
	@objc var decodeAsync: Bool = false
	@objc var borderRadius: NSNumber = 0
	var lastState: BlurhashCache?
	let imageContainer: UIImageView

	override init(frame: CGRect) {
		self.imageContainer = UIImageView()
		self.imageContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.imageContainer.clipsToBounds = true
		self.imageContainer.contentMode = .scaleAspectFill
		super.init(frame: frame)
		self.addSubview(self.imageContainer)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	final func decodeImage() -> UIImage? {
		guard let blurhash = self.blurhash else {
			return nil
		}
		if self.decodeWidth.intValue > 0, self.decodeHeight.intValue > 0, self.decodePunch.floatValue > 0 {
			log(level: .trace, message: "Decoding \(self.decodeWidth)x\(self.decodeHeight) blurhash (\(blurhash)) on \(Thread.isMainThread ? "main" : "separate") thread!")
			let size = CGSize(width: decodeWidth.intValue, height: self.decodeHeight.intValue)
			let nullableImage = UIImage(blurHash: blurhash as String, size: size, punch: self.decodePunch.floatValue)
			guard let image = nullableImage else {
				return nil
			}
			return image
		} else {
			log(level: .error, message: "Error! decodeWidth, decodeHeight and decodePunch must be greater than 0!")
			return nil
		}
	}

	final func renderBlurhashView() {
		if self.decodeAsync {
			DispatchQueue.global(qos: .userInteractive).async {
				let image = self.decodeImage()
				DispatchQueue.main.async {
					self.imageContainer.image = image
				}
			}
		} else {
			self.imageContainer.image = self.decodeImage()
		}
	}

	override final func didSetProps(_ changedProps: [String]!) {
		let shouldReRender = self.shouldReRender()
		if shouldReRender {
			self.renderBlurhashView()
		}
		if changedProps.contains("resizeMode") || changedProps.contains("borderRadius") {
			self.updateImageContainer()
		}
	}

	final func shouldReRender() -> Bool {
		defer {
			self.lastState = BlurhashCache(blurhash: self.blurhash, decodeWidth: self.decodeWidth, decodeHeight: self.decodeHeight, decodePunch: self.decodePunch)
		}
		guard let lastState = self.lastState else {
			return true
		}
		guard let blurhash = self.blurhash else {
			return true
		}
		return lastState.isDifferent(blurhash: blurhash, decodeWidth: self.decodeWidth, decodeHeight: self.decodeHeight, decodePunch: self.decodePunch)
	}

	final func updateImageContainer() {
		self.imageContainer.contentMode = self.parseResizeMode(resizeMode: self.resizeMode)
		if let cornerRadius = CGFloat(exactly: self.borderRadius) {
			// TODO: shouldRasterize ?
			let shouldRasterize = cornerRadius > 0 ? true : false
			self.imageContainer.layer.shouldRasterize = shouldRasterize
			if shouldRasterize {
				log(level: .trace, message: "Enabled rasterization for the UIImageView's layer.")
			}
			self.imageContainer.layer.cornerRadius = cornerRadius
		}
	}

	final func parseResizeMode(resizeMode: NSString) -> ContentMode {
		switch resizeMode {
		case "contain":
			return .scaleAspectFit
		case "cover":
			return .scaleAspectFill
		case "stretch":
			return .scaleToFill
		case "center":
			return .center
		default:
			return .scaleAspectFill
		}
	}
}
