import * as React from 'react';
import { requireNativeComponent, NativeModules, Platform, ViewProps, NativeSyntheticEvent } from 'react-native';
import { decode83, decodeDC, isBlurhashValid, RGB } from './utils';

// NativeModules automatically resolves 'BlurhashView' to 'BlurhashViewModule'
const BlurhashModule = NativeModules.BlurhashView;

export interface BlurhashProps extends Omit<ViewProps, 'children'> {
	/**
	 * The blurhash string to use. Example: `LGFFaXYk^6#M@-5c,1J5@[or[Q6`.
	 */
	blurhash: string;
	/**
	 * The width (resolution) to decode to. Higher values decrease performance, use `16` for large lists, otherwise you can increase it to `32`.
	 * @default 32
	 */
	decodeWidth?: number;
	/**
	 * The height (resolution) to decode to. Higher values decrease performance, use `16` for large lists, otherwise you can increase it to `32`.
	 * @default 32
	 */
	decodeHeight?: number;
	/**
	 * Adjusts the contrast of the output image. Tweak it if you want a different look for your placeholders.
	 * @default 1.0
	 */
	decodePunch?: number;
	/**
	 * Asynchronously decode the Blurhash on a background Thread instead of the UI-Thread.
	 * Read the [performance documentation](https://github.com/mrousavy/react-native-blurhash#performance)
	 * before enabling this.
	 * @default false
	 */
	decodeAsync?: boolean;
	/**
	 * Adjusts the resize mode of the image.
	 * @default 'cover'
	 */
	resizeMode?: 'cover' | 'contain' | 'stretch' | 'center';

	/**
	 * Emitted when the Blurhash received new parameters and started to decode the given `blurhash` string.
	 */
	onLoadStart?: () => void;

	/**
	 * Emitted when the Blurhash successfully decoded the given `blurhash` string and rendered the image to the `<Blurhash>` view.
	 */
	onLoadEnd?: () => void;

	/**
	 * Emitted when the Blurhash failed to decode/load.
	 */
	onLoadError?: (message?: string) => void;
}

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
		if (this.props.onLoadError != null) this.props.onLoadError(event?.nativeEvent?.message);
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

// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const NativeBlurhashView = requireNativeComponent<BlurhashProps>(
	'BlurhashView',
	// @ts-expect-error this second argument is still not public, but probably required for TurboModules.
	Blurhash,
);
