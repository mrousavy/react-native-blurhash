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
    final func createBlurhashFromImage(_ imageSource: Any, componentsX: NSNumber, componentsY: NSNumber, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.global(qos: .utility).async {
            // Load Image from URI using the React Native Bridge's Image Loader.
            // The RCTImageLoader supports http, https, base64 and local files (afaik).

            guard let source = RCTConvert.rctImageSource(imageSource) else {
                reject("INVALID_SOURCE", "The image source is invalid! Provided: \(imageSource)", nil)
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

            module.loadImage(with: source.request, size: source.size, scale: source.scale, clipped: false, resizeMode: .stretch, progressBlock: nil, partialLoad: nil, completionBlock: { error, image in
                if error != nil {
                    reject("LOAD_ERROR", "Failed to load URI!", error)
                    return
                }
                guard let image = image else {
                    reject("IMAGE_NULL", "No error was thrown but Image was null.", nil)
                    return
                }

                log(level: .trace, message: "Encoding \(componentsX)x\(componentsY) Blurhash from URI \(source.request.debugDescription)...")
                let blurhash = image.encodeBlurhash(numberOfComponents: (componentsX.intValue, componentsY.intValue))
                resolve(blurhash)
            })
        }
    }
}
