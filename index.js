const React = require('react');
const { requireNativeComponent, NativeModules } = require('react-native');
const { decode83, decodeDC } = require('./utils');

// TODO: use memo to fix "Invariant Violation: Tried to register two views with the same name BlurhashView" error
// NativeModules automatically resolves 'BlurhashView' to 'BlurhashViewModule'
const BlurhashModule = NativeModules.BlurhashView;

class Blurhash extends React.Component {
	render() {
		return <NativeBlurhashView {...this.props} />;
	}
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

// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const NativeBlurhashView = requireNativeComponent('BlurhashView', Blurhash);
module.exports = { Blurhash };
