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
final class BlurhashViewManager: RCTViewManager {
	override final func view() -> UIView! {
		return BlurhashView()
	}

	override static func requiresMainQueueSetup() -> Bool {
		return true
	}

	@objc(createBlurhashFromImage:componentsX:componentsY:resolver:rejecter:)
	final func createBlurhashFromImage(_ imageUri: NSString, componentsX: NSNumber, componentsY: NSNumber, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
		let formattedUri = imageUri.trimmingCharacters(in: .whitespacesAndNewlines) as String

		DispatchQueue.global(qos: .utility).async {
			if formattedUri.starts(with: "http") {
				// Load Image from HTTP/HTTPS URL using the React Native Bridge's Image Loader.
				guard let url = URL(string: formattedUri as String) else {
					reject("URI_NULL", "URI was null!", nil)
					return
				}
				if !self.bridge.isValid {
					reject("BRIDGE_NOT_SET", "Bridge was not set!", nil)
					return
				}
				guard let module = self.bridge.module(for: RCTImageLoader.self) as? RCTImageLoader else {
					reject("MODULE_NOT_FOUND", "Could not find RCTImageLoader module!", nil)
					return
				}

				module.loadImage(with: URLRequest(url: url), callback: { e, image in
					if e != nil {
						reject("LOAD_ERROR", "Failed to load URI!", e)
						return
					}
					guard let image = image else {
						reject("IMAGE_NULL", "No error was thrown but Image was null.", nil)
						return
					}

					log(level: .trace, message: "Encoding \(componentsX)x\(componentsY) Blurhash from URI \(imageUri)...")
					let blurhash = image.encodeBlurhash(numberOfComponents: (componentsX.intValue, componentsY.intValue))
					resolve(blurhash)
				})
			} else if formattedUri.starts(with: "data:image/") {
				// Load from Base64 String using UIImage+Base64 extension.
				guard let image = UIImage(base64: formattedUri) else {
					reject("LOAD_ERROR", "The Image could not be loaded from the Base64 URI.", nil)
					return
				}
				log(level: .trace, message: "Encoding \(componentsX)x\(componentsY) Blurhash from URI \(imageUri)...")
				let blurhash = image.encodeBlurhash(numberOfComponents: (componentsX.intValue, componentsY.intValue))
				resolve(blurhash)
			} else {
				reject("INVALID_URI", "The given URI was invalid! URIs must either start with `http` or `data:image/`", nil)
			}
		}
	}
}
