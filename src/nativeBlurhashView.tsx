import { requireNativeComponent } from 'react-native';
import type BlurhashProps from './blurhashProps';
import { Blurhash } from './index';

export default requireNativeComponent<BlurhashProps>(
	'BlurhashView',
	// @ts-expect-error this second argument is still not public, but probably required for TurboModules.
	Blurhash,
);
