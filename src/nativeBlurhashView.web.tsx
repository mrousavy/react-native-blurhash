import React, { useEffect, useState } from 'react';
import { View } from 'react-native';
import BlurhashCanvas from './canvas';
import type BlurhashProps from './blurhashProps';
import { decode } from 'blurhash';

export default function BlurhashView({
	blurhash,
	decodeHeight = 128,
	decodePunch,
	decodeWidth = 128,
	onLoadStart = () => null,
	onLoadEnd = () => null,
	onLoadError = () => null,
	style,
}: BlurhashProps) {
	const [decodedBlurhash, setDecodedBlurhash] = useState<null | Uint8ClampedArray>(null);
	useEffect(() => {
		try {
			onLoadStart();
			setDecodedBlurhash(decode(blurhash, decodeWidth, decodeHeight, decodePunch));
		} catch (e) {
			onLoadError(e);
		}
	}, [blurhash, decodeWidth, decodeHeight, decodePunch, onLoadError, onLoadStart]);

	return (
		<View style={style}>
			{decodedBlurhash ? <BlurhashCanvas decodedBlurhash={decodedBlurhash} height={decodeHeight} onLoadEnd={onLoadEnd} width={decodeWidth} /> : null}
		</View>
	);
}
