const React = require('react');
const { requireNativeComponent, NativeModules, Platform } = require('react-native');
const { decode83, decodeDC } = require('./utils');

const { useCallback } = React;

// NativeModules automatically resolves 'BlurhashView' to 'BlurhashViewModule'
const BlurhashModule = NativeModules.BlurhashView;

function BlurhashBase(props) {
	const _onLoadStart = useCallback(() => {
		if (props.onLoadStart != null) props.onLoadStart();
	}, [props]);
	const _onLoadEnd = useCallback(() => {
		if (props.onLoadEnd != null) props.onLoadEnd();
	}, [props]);
	const _onLoadError = useCallback(
		(event) => {
			if (props.onLoadError != null) props.onLoadError(event?.nativeEvent?.message);
		},
		[props],
	);

	return <NativeBlurhashView {...props} onLoadStart={_onLoadStart} onLoadEnd={_onLoadEnd} onLoadError={_onLoadError} />;
}

const BlurhashMemo = React.memo(BlurhashBase);

function Blurhash(props) {
	return <BlurhashMemo {...props} />;
}

Blurhash.encode = (imageUri, componentsX, componentsY) => {
	if (typeof imageUri !== 'string') throw new Error('imageUri must be a non-empty string!');
	if (typeof componentsX !== 'number') throw new Error('componentsX must be a valid positive number!');
	if (typeof componentsY !== 'number') throw new Error('componentsY must be a valid positive number!');

	return BlurhashModule.createBlurhashFromImage(imageUri, componentsX, componentsY);
};

Blurhash.getAverageColor = (blurhash) => {
	if (blurhash == null || blurhash.length < 7) return undefined;

	const value = decode83(blurhash.substring(2, 6));
	return decodeDC(value);
};

Blurhash.clearCosineCache = () => {
	if (Platform.OS === 'android') BlurhashModule.clearCosineCache();
};

Blurhash.displayName = 'Blurhash';

// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const NativeBlurhashView = requireNativeComponent('BlurhashView', Blurhash);

module.exports = { Blurhash };
