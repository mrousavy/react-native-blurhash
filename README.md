# Blurhash

> 🖼️ Give your users the loading experience they want.

Install via [npm](https://www.npmjs.com/package/react-native-blurhash):

```sh
npm i react-native-blurhash
cd ios; pod install; cd ..
```

<a href='https://ko-fi.com/F1F8CLXG' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

[![npm](https://img.shields.io/npm/v/react-native-blurhash?color=%238B83E6)](https://www.npmjs.com/package/react-native-blurhash)
[![npm](https://img.shields.io/npm/dt/react-native-blurhash?color=%238B83E6)](https://www.npmjs.com/package/react-native-blurhash)
[![GitHub stars](https://img.shields.io/github/stars/mrousavy/react-native-blurhash.svg?style=social&label=Star&maxAge=259000)](https://GitHub.com/mrousavy/react-native-blurhash/stargazers/)
[![GitHub followers](https://img.shields.io/github/followers/mrousavy.svg?style=social&label=Follow&maxAge=259000)](https://github.com/mrousavy?tab=followers)

**BlurHash** is a compact representation of a placeholder for an image. Instead of displaying boring grey little boxes while your image loads, show a _blurred preview_ until the full image has been loaded.

> The algorithm was created by [woltapp/blurhash](https://github.com/woltapp/blurhash), which also includes an [algorithm explanation](https://github.com/woltapp/blurhash/blob/master/Algorithm.md).

<img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/explanation.png" alt="Turn grey image boxes into colorful blurred images" width="70%">

## Example Workflow

<table>
<tr>
<td width="55%">
<ol>
  In order to use the Blurhash component, you have to already have a Blurhash string. See the <a href="https://blurha.sh">blurha.sh</a> page to create example strings.

  This is how I use it in my project:

  <li>A user uploads images from the react native app to firebase</li>
  <li>In firebase, I have a storage trigger function that generates a blurhash string from the uploaded image using the encoder from the <a href="https://github.com/woltapp/blurhash/blob/master/C/encode.c">C implementation</a>. (You can also use the <a href="#encoding">integrated encoder</a> to encode an Image straight out of your React Native App!)</li>
  <li>After I generated the blurhash string, I set this as a property on my <code>post</code> document in Firestore</li>
  <li>Now everytime a user loads a feed of <code>posts</code> from my Firestore database, I show a <code>&lt;Blurhash&gt;</code> component (with the post's <code>.blurhash</code> property) over my <code>&lt;Image&gt;</code> component, and fade it out once the <code>&lt;Image&gt;</code> component's <a href="https://reactnative.dev/docs/image#onloadend"><code>onLoadEnd</code></a> function has been called.</li>
</td>
<td width="25%">
<img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/demo.gif">
</td>
</tr>
</table>

## Usage

The decoders are written in [Swift](ios/BlurhashDecode.swift) and [Kotlin](android/src/main/java/com/mrousavy/blurhash/BlurhashDecode.kt) and are copied from the official [woltapp/blurhash](https://github.com/woltapp/blurhash) repository (MIT license). I use **light in-memory-caching** techniques to only re-render the (quite expensive) Blurhash image creation when one of the _blurhash specific_ props (`blurhash`, `decodeWidth`, `decodeHeight` or `decodePunch`) has changed.

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
    <td>The width (resolution) to decode to. Higher values decrease performance, use <code>16</code> for large lists, otherwise you can increase it to <code>32</code>.
    <br/>
    <blockquote>See: <a href="#performance">performance</a></blockquote></td>
    <td>❌</td>
    <td><code>32</code></td>
  </tr>
  <tr>
    <td><code>decodeHeight</code></td>
    <td><code>number</code></td>
    <td>The height (resolution) to decode to. Higher values decrease performance, use <code>16</code> for large lists, otherwise you can increase it to <code>32</code>.
    <br/>
    <blockquote>See: <a href="#performance">performance</a></blockquote></td>
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
    <td><code>decodeAsync</code></td>
    <td><code>boolean</code></td>
    <td>Asynchronously decode the Blurhash on a background Thread instead of the UI-Thread.
    <br/>
    <blockquote>See: <a href="#asynchronous-decoding">Asynchronous Decoding</a></blockquote></td>
    <td>❌</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>resizeMode</code></td>
    <td><code>'cover' | 'contain' | 'stretch' | 'center'</code></td>
    <td>Sets the resize mode of the image. (no, <code>'repeat'</code> is not supported.)
    <blockquote>See: <a href="https://reactnative.dev/docs/image#resizemode">Image::resizeMode</a></blockquote>
    </td>
    <td>❌</td>
    <td><code>'cover'</code></td>
  </tr>
  <tr>
    <td><code>onLoadStart</code></td>
    <td><code>(event: BlurhashLoadStartEvent) => void</code></td>
    <td>Emitted when the Blurhash received new parameters and started to decode the given <code>blurhash</code> string.</td>
    <td>❌</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><code>onLoadEnd</code></td>
    <td><code>(event: BlurhashLoadEndEvent) => void</code></td>
    <td>Emitted when the Blurhash successfully decoded the given <code>blurhash</code> string and rendered the image to the <code>&lt;Blurhash&gt;</code> view.</td>
    <td>❌</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td><code>onLoadError</code></td>
    <td><code>(event: BlurhashLoadErrorEvent) => void</code></td>
    <td>Emitted when the Blurhash failed to load. Use <code>event.nativeEvent.message</code> to get the error message.</td>
    <td>❌</td>
    <td><code>null</code></td>
  </tr>
  <tr>
    <td>All <code>View</code> props</td>
    <td><code>ViewProps</code></td>
    <td>All properties from the React Native <code>View</code>. Use <code>style.width</code> and <code>style.height</code> for display-sizes. Also, <code>style.borderRadius</code> is natively supported on iOS.</td>
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

> See the [example](example/) App for a full code example.

<table>
  <tr>
    <th>iOS Screenshot</th>
    <th>Android Screenshot</th>
  </tr>
  <tr>
    <td width="50%"><img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/demo_ios.png" alt="iOS Demo Screenshot"></td>
    <td width="50%"><img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/demo_android.png" alt="Android Demo Screenshot"></td>
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

## Average Color

If your app is **really colorful** you might want to match some containers' colors to the content's context. To achieve this, use the `getAverageColor` function to get an RGB value which represents the average color of the given Blurhash:

```ts
const averageColor = Blurhash.getAverageColor('LGFFaXYk^6#M@-5c,1J5@[or[Q6.')
```

## Encoding

This library also includes a **native Image encoder**, so you can **encode** Images to blurhashes straight out of your React Native App!

```ts
const blurhash = await Blurhash.encode('https://blurha.sh/assets/images/img2.jpg', 4, 3)
```

Because encoding an Image is a pretty heavy task, this function is **non-blocking** and runs on a separate background Thread.

## Performance

The performance of the decoders is really fast, which means you should be able to use them in collections quite easily. By increasing the `decodeWidth` and `decodeHeight` props, the _time to decode_ also increases. I'd recommend values of `16` for large lists, and `32` otherwise. Play around with the values but keep in mind that you probably won't see a difference when increasing it to anything above `32`.

### Asynchronous Decoding

Use `decodeAsync={true}` to decode the Blurhash on a separate background Thread instead of the main UI-Thread. This is useful when you are experiencing stutters because of the Blurhash's **decoder** - e.g.: in large Lists.

Threads are re-used (iOS: `DispatchQueue`, Android: kotlinx Coroutines).

### Caching

Previously rendered Blurhashes will get cached, so they don't re-decode on every state change, as long as the `blurhash`, `decodeWidth`, `decodeHeight` and `decodePunch` properties stay the same.

## Resources
* [this medium article.](https://teabreak.e-spres-oh.com/swift-in-react-native-the-ultimate-guide-part-2-ui-components-907767123d9e) jesus christ amen thanks for that
* [Native Modules documentation](https://reactnative.dev/docs/native-modules-ios.html), especially the [Swift part](https://reactnative.dev/docs/native-modules-ios.html#exporting-swift)
* [This cheatsheet gist](https://gist.github.com/chourobin/f83f3b3a6fd2053fad29fff69524f91c) thank you @chourobin.
* [DylanVann/react-native-fast-image](https://github.com/DylanVann/react-native-fast-image) as a reference for native UI modules
* [woltapp/blurhash](https://github.com/woltapp/blurhash) of course


<a href='https://ko-fi.com/F1F8CLXG' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
