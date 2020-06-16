# Blurhash

> Make loading not so boring.

Install via [npm](https://www.npmjs.com/package/react-native-blurhash):

```sh
npm i react-native-blurhash
cd ios; pod install; cd ..
```

<a href='https://ko-fi.com/F1F8CLXG' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**BlurHash** is a compact representation of a placeholder for an image. This is a native UI module for React Native to wrap the Blurhash iOS and Android implementations and make them usable in React Native. See [woltapp/blurhash](https://github.com/woltapp/blurhash)

<img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/explanation.png" alt="Turn grey image boxes into colorful blurred images">

## Example Workflow

In order to use the Blurhash component, you have to already have a Blurhash string. See the [blurha.sh](https://blurha.sh) page to create example strings.

This is how I use it in my project:

1. A user uploads images from the react native app to firebase
2. In firebase, I have a storage trigger function that generates a blurhash string from the uploaded image using the [TypeScript implementation](https://github.com/woltapp/blurhash/blob/master/TypeScript/src/encode.ts)
3. After I generated the blurhash string, I set this as a property on my `post` document in Firestore.
4. Now everytime a user loads a feed of posts from my Firestore database, I use a `<Blurhash>` component (with the post's `blurhash` property) over my `<Image>` component, and fade it out once the `<Image>` component's [`onLoadEnd`](https://reactnative.dev/docs/image#onloadend) function has been called.

## Usage

The decoders are written in [Swift](ios/BlurhashDecode.swift) and [Kotlin](android/src/main/java/com/mrousavy/blurhash/BlurhashDecode.kt), and are copied from the official [woltapp/blurhash](https://github.com/woltapp/blurhash) repository. I use caching techniques, to only re-render the (quite expensive) Blurhash image creation when one of the blurhash specific props (`blurhash`, `decodeWidth`, `decodeHeight` or `decodePunch`) has changed.

<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Explanation</th>
    <th>Required</th>
    <th>Default Value</th>
  </td>
  <tr>
    <td><code>blurhash</code></td>
    <td><code>string</code></td>
    <td>The blurhash string to use. Example: <code>LGFFaXYk^6#M@-5c,1J5@[or[Q6.</code></td>
    <td>✅</td>
    <td><code>undefined</code></td>
  </tr>
  <tr>
    <td><code>decodeWidth</code></td>
    <td><code>number</code></td>
    <td>The width (resolution) to decode to. This is not the same as the React Component's Style width! Higher values decrease performance, <code>32</code> is plenty!</td>
    <td>❌</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><code>decodeHeight</code></td>
    <td><code>number</code></td>
    <td>The height (resolution) to decode to. This is not the same as the React Component's Style height! Higher values decrease performance, <code>32</code> is plenty!</td>
    <td>❌</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><code>decodePunch</code></td>
    <td><code>number</code></td>
    <td>Adjusts the contrast of the output image. Tweak it if you want a different look for your placeholders.</td>
    <td>❌</td>
    <td><code>1.0</code></td>
  </tr>
  <tr>
    <td><code>resizeMode</code></td>
    <td><code>'cover' | 'contain' | 'stretch' | 'center'</code></td>
    <td>Sets the resize mode of the image. See: <a href="https://reactnative.dev/docs/image#resizemode">Image:resizeMode</a></td>
    <td>❌</td>
    <td><code>'contain'</code></td>
  </tr>
  <tr>
    <td>All <code>View</code> props</td>
    <td><code>ViewProps</code></td>
    <td>All properties from the React Native <code>View</code>. Use <code>style.width</code> and <code>style.height</code> for render-widths.</td>
    <td>❌</td>
    <td><code>{}</code></td>
  </tr>
</table>

> Read the [algorithm description](https://github.com/woltapp/blurhash/blob/master/Algorithm.md) for more details

Example Usage:

```tsx
import { Blurhash } from 'react-native-blurhash';

export default function App() {
  return (
    <Blurhash
      blurhash="LGFFaXYk^6#M@-5c,1J5@[or[Q6."
      style={{flex: 1}}
    />
  );
}
```

### Example App

<table>
  <tr>
    <th>iOS Screenshot</th>
    <th>Android Screenshot</th>
  </td>
  <tr>
    <td><img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/demo.ios.png" alt="iOS Demo Screenshot"></td>
    <td><img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/demo.android.png" alt="Android Demo Screenshot"></td>
  </tr>
</table>

To run the example App, execute the following commands:

```sh
cd react-native-blurhash/example/
yarn
cd ios; pod install; cd ..
npm run ios
npm run android
```


## Performance

The performance of the decoders is really fast, which means you should be able to use them in collections quite easily. Make sure to expect a small delay though, since it is still a complex decoding algorithm. By increasing the `decodeWidth` and `decodeHeight` props, the performance decreases. If you don't care much about the render resolution, use lower `decodeWidth` and `decodeHeight` values (`32` pixels wide is plenty!), and increase `style.width` and `style.height` values (or upscale it any other way like `flex`, `scale`, ...).

With both `decodeWidth` and `decodeHeight` set to `16` the image decoding takes about `2` milliseconds on iOS. For comparison, setting both `decodeWidth` and `decodeHeight` to `400` increases the decoding time to around `1.186` milliseconds.

At the moment, the Android decoder is faster than the iOS decoder, I'm not quite sure why.


## Resources
* [this medium article. jesus christ amen thanks for that](https://teabreak.e-spres-oh.com/swift-in-react-native-the-ultimate-guide-part-2-ui-components-907767123d9e)
* [Native Modules documentation, especially the Swift part](https://reactnative.dev/docs/native-modules-ios.html#exporting-swift)


<a href='https://ko-fi.com/F1F8CLXG' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
