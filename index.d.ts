import React from 'react';
import { ViewProps } from 'react-native';

export declare interface BlurhashProps extends ViewProps {
  /**
   * The blurhash string to use. Example: `LGFFaXYk^6#M@-5c,1J5@[or[Q6`.
   */
  blurhash: string;
  /**
   * The width (resolution) to decode to. This is not the same as the React Component's Style width! Higher values decrease performance, `32` is plenty!
   * @default 32
   */
  decodeWidth?: number;
  /**
   * The height (resolution) to decode to. This is not the same as the React Component's Style height! Higher values decrease performance, `32` is plenty!
   * @default 32
   */
  decodeHeight?: number;
  /**
   * Adjusts the contrast of the output image. Tweak it if you want a different look for your placeholders.
   * @default 1.0
   */
  decodePunch?: number;
}

export declare class Blurhash extends React.Component<BlurhashProps> {
  public render(): React.ReactNode;
}
