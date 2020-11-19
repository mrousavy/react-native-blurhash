/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 *
 * @format
 */
const path = require('path');
const blacklist = require('metro-config/src/defaults/blacklist');

module.exports = {
  resolver: {
    blacklistRE: blacklist([
      // This stops "react-native run-windows" from causing the metro server to crash if its already running
      new RegExp(
        `${path.resolve(__dirname, 'windows').replace(/[/\\]/g, '/')}.*`,
      ),
      // This prevents "react-native run-windows" from hitting: EBUSY: resource busy or locked, open msbuild.ProjectImports.zip
      new RegExp(
        `${path
          .resolve(__dirname, 'msbuild.ProjectImports.zip')
          .replace(/[/\\]/g, '/')}.*`,
      ),
    ]),
    // workaround for an issue with symlinks encountered starting with
    // metro@0.55 / React Native 0.61
    // (not needed with React Native 0.60 / metro@0.54)
    extraNodeModules: new Proxy(
      {},
      { get: (_, name) => path.resolve('.', 'node_modules', name) }
    )
  },
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: false,
      },
    }),
  },
  // quick workaround for another issue with symlinks
  watchFolders: ['.', '..']
};
