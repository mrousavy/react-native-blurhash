import React, { useEffect, useRef } from 'react';

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
  const canvasRef = useRef<HTMLCanvasElement>(null);
  useEffect(() => {
    if (!canvasRef.current) return;
    const ctx = canvasRef?.current?.getContext('2d');
    if (!ctx) return;
    const imageData = ctx.createImageData(width, height);
    imageData.data.set(decodedBlurhash);
    ctx.putImageData(imageData, 0, 0);
    onLoadEnd();
  }, [canvasRef, decodedBlurhash, height, width, onLoadEnd]);

  return <canvas {...rest} height={height} width={width} ref={canvasRef} />
};
