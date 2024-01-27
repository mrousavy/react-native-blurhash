//
//  BlurhashCache.swift
//  Blurhash
//
//  Created by Marc Rousavy on 04.09.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

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

    final func isDifferent(blurhash: String, decodeWidth: Int, decodeHeight: Int, decodePunch: Float) -> Bool {
        return self.blurhash != blurhash || self.decodeWidth != decodeWidth || self.decodeHeight != decodeHeight || self.decodePunch != decodePunch
    }
}
