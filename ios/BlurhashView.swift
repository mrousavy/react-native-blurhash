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
	@objc var blurhash: NSString = "LEHV6nWB2yk8pyo0adR*.7kCMdnj"
	@objc var width: NSNumber = 400
	@objc var height: NSNumber = 300
	@objc var punch: NSNumber = 1
	
	lazy var image: UIImage? = {
		// b.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		var size = CGSize(width: self.width.intValue, height: self.height.intValue)
		return UIImage(blurHash: blurhash as String, size: size, punch: self.punch.floatValue)
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		if (self.image != nil) {
			self.addSubview(UIImageView(image: self.image))
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}
}
