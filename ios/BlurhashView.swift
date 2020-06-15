//
//  BlurhashView.swift
//  Blurhash
//
//  Created by Marc Rousavy on 15.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit


class BlurhashView: UIView {
	// TODO: Re-render on props change?
	@objc var blurhash: NSString = "LEHV6nWB2yk8pyo0adR*.7kCMdnj" {
		didSet {
			self.renderBlurhashView()
		}
	}
	@objc var width: NSNumber = 400 {
		didSet {
			self.renderBlurhashView()
		}
	}
	@objc var height: NSNumber = 300 {
		didSet {
			self.renderBlurhashView()
		}
	}
	@objc var punch: NSNumber = 1 {
		didSet {
			self.renderBlurhashView()
		}
	}
	
	var imageContainer: UIImageView
	
	override init(frame: CGRect) {
		self.imageContainer = UIImageView(frame: frame)
		super.init(frame: frame)
		self.addSubview(imageContainer)
		print("Initial Rendering { \(self.width):\(self.height) } view for \(self.blurhash) (\(self.punch))")
	}
	
	required init?(coder aDecoder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}
	
	func renderBlurhashView() {
		print("Re-Rendering { \(self.width):\(self.height) } view for \(self.blurhash) (\(self.punch))")
		DispatchQueue.main.async {
			let size = CGSize(width: self.width.intValue, height: self.height.intValue)
			let image = UIImage(blurHash: self.blurhash as String, size: size, punch: self.punch.floatValue)
			// image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			self.imageContainer.image = image
			self.imageContainer.setNeedsDisplay()
			self.addSubview(UIImageView(image: image))
		}
	}
}
