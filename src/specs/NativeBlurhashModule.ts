import { type TurboModule, TurboModuleRegistry } from 'react-native';
import type { Int32 } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
	createBlurhashFromImage: (imageUri: string, componentsX: Int32, componentsY: Int32) => Promise<string>;
	clearCosineCache: () => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('BlurhashModule');
