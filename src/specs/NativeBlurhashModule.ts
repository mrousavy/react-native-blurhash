import { type TurboModule, TurboModuleRegistry } from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
	createBlurhashFromImage: (imageUri: string, componentsX: Double, componentsY: Double) => Promise<string>;
	clearCosineCache: () => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('BlurhashModule');
