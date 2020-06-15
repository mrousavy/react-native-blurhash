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
	override func view() -> UIView! {
		return BlurhashView()
	}
	
	override static func requiresMainQueueSetup() -> Bool {
		return false
	}
}
