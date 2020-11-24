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
            // Load Image from URI using the React Native Bridge's Image Loader.
            // The RCTImageLoader supports http, https, base64 and local files (afaik).
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

                let blurhash = image.encodeBlurhash(numberOfComponents: (componentsX.intValue, componentsY.intValue))
                resolve(blurhash)
            })
        }
    }
}
