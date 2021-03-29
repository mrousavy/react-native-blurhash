import { encode } from 'blurhash';

type BlurhashModule = {
  createBlurhashFromImage: (imageUri: string, componentsX: number, componentsY: number) => Promise<string>,
  clearCosineCache: () => void
};

async function createBlurhashFromImage (imageUri: string, componentsX: number, componentsY: number): Promise<string> {
  const image = await loadImage(imageUri);
  const imageData = getImageData(image);
  if (!imageData) return '';
  return encode(imageData.data, imageData.width, imageData.height, componentsX, componentsY);
}

const loadImage = (src: string): Promise<HTMLImageElement> =>
  new Promise((resolve, reject) => {
    const img = document.createElement('img');
    img.crossOrigin = 'Anonymous';
    img.onload = () => resolve(img);
    img.onerror = (...args) => reject(args);
    img.src = src;
  });

const getImageData = (image: HTMLImageElement) => {
  const canvas: HTMLCanvasElement = document.createElement('canvas');
  canvas.width = image.width;
  canvas.height = image.height;
  const context = canvas.getContext('2d');
  if (!context) return null;
  context.drawImage(image, 0, 0);
  return context.getImageData(0, 0, image.width, image.height);
};

const BlurhashModule: BlurhashModule = {
  createBlurhashFromImage,
  clearCosineCache: () => null,
};

export default BlurhashModule;
