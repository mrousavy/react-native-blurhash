//
//  BlurhashHelper.swift
//  Blurhash
//
//  Created by Marc Rousavy on 10.07.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

// MARK: Helper funcs

func signPow(_ value: Float, _ exp: Float) -> Float {
	return copysign(pow(abs(value), exp), value)
}

func linearTosRGB(_ value: Float) -> Int {
	let v = max(0, min(1, value))
	if v <= 0.0031308 { return Int(v * 12.92 * 255 + 0.5) }
	else { return Int((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5) }
}

func sRGBToLinear<Type: BinaryInteger>(_ value: Type) -> Float {
	let v = Float(Int64(value)) / 255
	if v <= 0.04045 { return v / 12.92 }
	else { return pow((v + 0.055) / 1.055, 2.4) }
}

// MARK: Encoder

let encodeCharacters: [String] = {
	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~".map { String($0) }
}()

func encodeDC(_ value: (Float, Float, Float)) -> Int {
	let roundedR = linearTosRGB(value.0)
	let roundedG = linearTosRGB(value.1)
	let roundedB = linearTosRGB(value.2)
	return (roundedR << 16) + (roundedG << 8) + roundedB
}

func encodeAC(_ value: (Float, Float, Float), maximumValue: Float) -> Int {
	let quantR = Int(max(0, min(18, floor(signPow(value.0 / maximumValue, 0.5) * 9 + 9.5))))
	let quantG = Int(max(0, min(18, floor(signPow(value.1 / maximumValue, 0.5) * 9 + 9.5))))
	let quantB = Int(max(0, min(18, floor(signPow(value.2 / maximumValue, 0.5) * 9 + 9.5))))

	return quantR * 19 * 19 + quantG * 19 + quantB
}

// MARK: Decoder

let decodeCharacters: [String: Int] = {
	var dict: [String: Int] = [:]
	for (index, character) in encodeCharacters.enumerated() {
		dict[character] = index
	}
	return dict
}()

func decodeDC(_ value: Int) -> (Float, Float, Float) {
	let intR = value >> 16
	let intG = (value >> 8) & 255
	let intB = value & 255
	return (sRGBToLinear(intR), sRGBToLinear(intG), sRGBToLinear(intB))
}

func decodeAC(_ value: Int, maximumValue: Float) -> (Float, Float, Float) {
	let quantR = value / (19 * 19)
	let quantG = (value / 19) % 19
	let quantB = value % 19

	let rgb = (
		signPow((Float(quantR) - 9) / 9, 2) * maximumValue,
		signPow((Float(quantG) - 9) / 9, 2) * maximumValue,
		signPow((Float(quantB) - 9) / 9, 2) * maximumValue
	)

	return rgb
}
