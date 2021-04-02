// metro.config.js
//
// with multiple workarounds for this issue with symlinks:
// https://github.com/facebook/metro/issues/1
//
// with thanks to @johnryan (<https://github.com/johnryan>)
// for the pointers to multiple workaround solutions here:
// https://github.com/facebook/metro/issues/1#issuecomment-541642857
//
// see also this discussion:
// https://github.com/brodybits/create-react-native-module/issues/232

const path = require('path');
const exclusionList = require('metro-config/src/defaults/exclusionList');
const escape = require('escape-string-regexp');
const pak = require('../package.json');

const root = path.resolve(__dirname, '..');

const modules = Object.keys({
	...pak.peerDependencies,
});

module.exports = {
	// workaround for an issue with symlinks encountered starting with
	// metro@0.55 / React Native 0.61
	// (not needed with React Native 0.60 / metro@0.54)
	resolver: {
		blacklistRE: exclusionList(modules.map((m) => new RegExp(`^${escape(path.join(root, 'node_modules', m))}\\/.*$`))),

		extraNodeModules: new Proxy({}, { get: (_, name) => path.resolve('.', 'node_modules', name) }),
	},

	// quick workaround for another issue with symlinks
	watchFolders: ['.', '..'],
};
