const React = require('react');
const { requireNativeComponent, NativeModules, UIManager, Platform } = require('react-native');

// TODO: use memo to fix "Cannot redeclare BlurhashView twice" error
const BlurhashModule = NativeModules.BlurhashViewManager;

class Blurhash extends React.Component {
  render() {
    return (
      <NativeBlurhashView {...this.props} />
    );
  }
}


Blurhash.encode = (imageUri, componentsX, componentsY) => {
  if (Platform.OS === 'ios') return BlurhashModule.createBlurhashFromImage(imageUri, componentsX, componentsY);
  else throw new Error("Blurhash Encoding is currently only supported on iOS! Create a pull request and help implementing this on Android here: https://github.com/mrousavy/react-native-blurhash/issues/9")
}

// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const NativeBlurhashView = requireNativeComponent('BlurhashView', Blurhash);
module.exports = { Blurhash };
