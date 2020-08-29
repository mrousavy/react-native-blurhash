module.exports = {
	root: true,
	parserOptions: {
		ecmaFeatures: {
			jsx: true,
		},
		ecmaVersion: 2018,
	},
	plugins: ['react', 'react-native', '@react-native-community', 'prettier'],
	extends: ['eslint:recommended', 'plugin:react/recommended', 'plugin:prettier/recommended', '@react-native-community'],
	rules: {
		// eslint
		semi: 'off',
		curly: ['warn', 'multi-or-nest', 'consistent'],
		'no-bitwise': 'off', // required for blurhash
		'no-mixed-spaces-and-tabs': ['warn', 'smart-tabs'],
		'no-async-promise-executor': 'warn',
		'require-await': 'warn',
		'no-return-await': 'warn',
		'no-await-in-loop': 'warn',
		'comma-dangle': 'off', // prettier already detects this
		// prettier
		'prettier/prettier': ['warn'],
		// react plugin
		'react/no-unescaped-entities': 'off',
		// react native plugin
		'react-native/no-unused-styles': 'warn',
		'react-native/split-platform-components': 'warn',
		'react-native/no-inline-styles': 'warn', // TODO: 'off'?
		'react-native/no-color-literals': 'warn',
		'react-native/no-raw-text': 'off',
		'react-native/no-single-element-style-arrays': 'warn',
	},
	env: {
		node: true,
		'react-native/react-native': true,
	},
	settings: {
		react: {
			version: 'latest',
		},
		'import/resolver': {
			extensions: [
				'.js',
				'.jsx',
				'.ts',
				'.tsx',
				'.d.ts',
				'.android.js',
				'.android.jsx',
				'.android.ts',
				'.android.tsx',
				'.ios.js',
				'.ios.jsx',
				'.ios.ts',
				'.ios.tsx',
				'.web.js',
				'.web.jsx',
				'.web.ts',
				'.web.tsx',
			],
		},
	},
};
