import React from 'react';
import { requireNativeComponent } from 'react-native';


export interface BlurhashProps {
  blurhash: string;
  width: number;
  height: number;
  punch: number;
}

class BlurhashView extends React.Component<BlurhashProps> {
  constructor(props: BlurhashProps) {
    super(props);
  }

  render() {
    return (<Blurhash {...this.props} />);
  }
}


// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const Blurhash = requireNativeComponent<BlurhashProps>('BlurhashView');
export default Blurhash;
