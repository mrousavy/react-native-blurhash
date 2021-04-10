import { NativeModules } from 'react-native';
const BlurhashModule: BlurhashModule = NativeModules.BlurhashView;

type BlurhashModule = {
	createBlurhashFromImage: (imageUri: string, componentsX: number, componentsY: number) => Promise<string>;
	clearCosineCache: () => void;
};

export default BlurhashModule;
