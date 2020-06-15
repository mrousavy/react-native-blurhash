import React from 'react';
import { requireNativeComponent, ViewProps } from 'react-native';


export interface BlurhashProps extends ViewProps {
  blurhash: string;
  width: number;
  height: number;
  punch?: number;
}

// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const Blurhash = requireNativeComponent<BlurhashProps>('BlurhashView');
export default Blurhash;
