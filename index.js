const React = require('react');
const { requireNativeComponent } = require('react-native');

class Blurhash extends React.Component {
  render() {
    return (
      <NativeBlurhashView {...this.props} />
    );
  }
}

// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const NativeBlurhashView = requireNativeComponent('BlurhashView', Blurhash);
module.exports = { Blurhash };
