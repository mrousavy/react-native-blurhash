import React, { useCallback } from 'react';

export type Props = React.CanvasHTMLAttributes<HTMLCanvasElement> & {
  getContext?: Function;
  decodedBlurhash: Uint8ClampedArray;
  height?: number;
  onLoadEnd: Function;
  punch?: number;
  width?: number;
};

export default function BlurhashCanvas ({
  // TODO: See how canvas handles unset width/height
  decodedBlurhash,
  height = 128,
  onLoadEnd,
  width = 128,
  ...rest
}: Props) {
  const canvasRef = useCallback((canvas: Props) => {
    if (!canvas) return;
    const ctx = canvas.getContext && canvas.getContext('2d');
    const imageData = ctx.createImageData(width, height);
    imageData.data.set(decodedBlurhash);
    ctx.putImageData(imageData, 0, 0);
    onLoadEnd();
  }, [decodedBlurhash, height, width, onLoadEnd]);

  return <canvas {...rest} height={height} width={width} ref={canvasRef} />
};
