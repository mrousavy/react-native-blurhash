'use strict';

import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport'
import {TurboModuleRegistry} from 'react-native'

export interface Spec extends TurboModule {
  +getConstants: () => {||};

  +createBlurhashFromImage(imageUri: string, componentsX: number, componentsY: number): Promise<string>;
}

export default (TurboModuleRegistry.get<Spec>('BlurhashModule'): ?Spec);
