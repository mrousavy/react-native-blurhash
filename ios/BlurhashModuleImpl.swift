//
//  BlurhashModuleImpl.swift
//  Blurhash
//
//  Created by Marc Rousavy on 08.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

@objc
public final class BlurhashModuleImpl: NSObject {
    private var moduleRegistry: RCTModuleRegistry

    @objc
    public init(moduleRegistry: RCTModuleRegistry) {
        self.moduleRegistry = moduleRegistry
    }

    @objc
    public func createBlurhashFromImage(_ imageUri: String, componentsX: Int, componentsY: Int, resolver resolve: @escaping (String) -> Void, rejecter reject: @escaping (String, String, Error?) -> Void) {
        let formattedUri = imageUri.trimmingCharacters(in: .whitespacesAndNewlines)

        DispatchQueue.global(qos: .utility).async {
            // Load Image from URI using the React Native Bridge's Image Loader.
            // The RCTImageLoader supports http, https, base64 and local files (afaik).
            guard let url = URL(string: formattedUri as String) else {
                reject("URI_NULL", "URI was null!", nil)
                return
            }

            guard let module = self.moduleRegistry.module(forName: "ImageLoader") as? RCTImageLoader else {
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

                guard let blurhash = image.encodeBlurhash(numberOfComponents: (componentsX, componentsY)) else {
                    reject("ENCODE_FAILED", "Failed to encode the image.", nil)
                    return
                }
                resolve(blurhash)
            })
        }
    }
}
