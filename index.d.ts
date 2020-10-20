import React from 'react';
import { ImageURISource, ViewProps } from 'react-native';

export declare interface RGB {
	/**
	 * The Red value component of this RGB instance. Ranges from 0 to 255.
	 */
	r: number;
	/**
	 * The Green value component of this RGB instance. Ranges from 0 to 255.
	 */
	g: number;
	/**
	 * The Blue value component of this RGB instance. Ranges from 0 to 255.
	 */
	b: number;
}

export declare interface BlurhashProps extends ViewProps {
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
	 *
	 * Please see: https://github.com/mrousavy/react-native-blurhash#performance
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
	 * Emitted when the Blurhash failed to load.
	 */
	onLoadError?: (message?: string) => void;
}

export declare class Blurhash extends React.Component<BlurhashProps> {
	public render(): React.ReactNode;
	/**
	 * Asynchronously encode an Image URI to a Blurhash.
	 * @param imageSource The Image URI source to use.
	 * @param componentsX The components for the X axis.
	 * @param componentsY The components for the Y axis.
	 * @returns A promise which resolves with the Blurhash string, or rejects if an error occured.
	 * @example
	 * const blurhash = await Blurhash.encode('https://blurha.sh/assets/images/img2.jpg')
	 */
	public static encode(imageSource: ImageURISource, componentsX: number, componentsY: number): Promise<string>;

	/**
	 * Get the average color from a Blurhash string by decoding digits 3 to 6. (See [Algorithm Structure](https://github.com/woltapp/blurhash/blob/master/Algorithm.md#structure))
	 * @param blurhash The Blurhash string to extract the average color from.
	 * @returns The Blurhashes average color in RGB format, or undefined if invalid Blurhash.
	 * @example
	 * const averageColor = Blurhash.getAverageColor(`LGFFaXYk^6#M@-5c,1J5@[or[Q6.`)
	 */
	public static getAverageColor(blurhash: string): RGB | undefined;

	/**
	 * Clear the Android Cosine operations array cache. Call this function if your memory usage is high.
	 *
	 * _Note: This is a no-op on iOS._
	 *
	 * @platform Android
	 * @see https://github.com/mrousavy/react-native-blurhash#cosine-operations
	 */
	public static clearCosineCache(): void;
}
