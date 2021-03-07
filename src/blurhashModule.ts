import { NativeModules, Platform } from 'react-native';
const BlurhashModule: BlurhashModule = Platform.select({
  web: null,
  native: NativeModules.BlurhashModule,
});

type BlurhashModule = {
  createBlurhashFromImage: (imageUri: string, componentsX: number, componentsY: number) => Promise<string>,
  clearCosineCache: () => void
};

export default BlurhashModule;
