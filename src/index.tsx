import * as React from 'react';
import { Platform, NativeSyntheticEvent } from 'react-native';
import { decode83, decodeDC, isBlurhashValid, RGB } from './utils';
import type BlurhashProps from './blurhashProps';
// NativeModules automatically resolves 'BlurhashView' to 'BlurhashViewModule'
import BlurhashModule from './blurhashModule';
import NativeBlurhashView from './nativeBlurhashView';

export class Blurhash extends React.PureComponent<BlurhashProps> {
	static displayName = 'Blurhash';

	constructor(props: BlurhashProps) {
		super(props);
		this._onLoadStart = this._onLoadStart.bind(this);
		this._onLoadEnd = this._onLoadEnd.bind(this);
		this._onLoadError = this._onLoadError.bind(this);
	}

	/**
	 * Encodes the given image URI to a blurhash string
	 * @param imageUri An URI to an Image parseable by the react native image loader
	 * @param componentsX The number of X components
	 * @param componentsY The number of Y components
	 * @example
	 * const blurhash = await Blurhash.encode('https://blurha.sh/assets/images/img2.jpg')
	 */
	static encode(imageUri: string, componentsX: number, componentsY: number): Promise<string> {
		if (typeof imageUri !== 'string') throw new Error('imageUri must be a non-empty string!');
		if (typeof componentsX !== 'number') throw new Error('componentsX must be a valid positive number!');
		if (typeof componentsY !== 'number') throw new Error('componentsY must be a valid positive number!');

		return BlurhashModule.createBlurhashFromImage(imageUri, componentsX, componentsY);
	}

	/**
	 * Gets the average color in a given blurhash string.
	 *
	 * This uses the JS blurhash decoder, so it might be slow.
	 * @param blurhash The blurhash string
	 * @example
	 * const averageColor = Blurhash.getAverageColor(`LGFFaXYk^6#M@-5c,1J5@[or[Q6.`)
	 */
	static getAverageColor(blurhash: string): RGB | undefined {
		if (blurhash == null || blurhash.length < 7) return undefined;

		const value = decode83(blurhash.substring(2, 6));
		return decodeDC(value);
	}

	/**
	 * Clears the cosine cache and frees up memory.
	 *
	 * @platform Android
	 * @see https://github.com/mrousavy/react-native-blurhash#cosine-operations
	 */
	static clearCosineCache(): void {
		if (Platform.OS === 'android') BlurhashModule.clearCosineCache();
		else console.warn('Blurhash.clearCosineCache is only available on Android.');
	}

	/**
	 * Verifies if the given blurhash is valid by checking it's type, length and size flag.
	 *
	 * This uses the JS blurhash decoder, so it might be slow.
	 * @param blurhash The given blurhash string
	 */
	static isBlurhashValid(blurhash: string): ReturnType<typeof isBlurhashValid> {
		return isBlurhashValid(blurhash);
	}

	_onLoadStart() {
		if (this.props.onLoadStart != null) this.props.onLoadStart();
	}
	_onLoadEnd() {
		if (this.props.onLoadEnd != null) this.props.onLoadEnd();
	}
	_onLoadError(event?: NativeSyntheticEvent<{ message?: string }>) {
		if (this.props.onLoadError != null) {
			const message = event?.nativeEvent?.message; // TODO: Not sure how to get proper value here on web
			this.props.onLoadError(message);
		}
	}

	render() {
		return (
			<NativeBlurhashView
				{...this.props}
				onLoadStart={this._onLoadStart}
				onLoadEnd={this._onLoadEnd}
				// @ts-expect-error
				onLoadError={this._onLoadError}
			/>
		);
	}
}
