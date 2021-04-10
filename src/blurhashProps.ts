import type { ViewProps } from 'react-native';

export default interface BlurhashProps extends Omit<ViewProps, 'children'> {
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
