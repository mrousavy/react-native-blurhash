<a href="https://github.com/sponsors/mrousavy">
  <img align="right" width="160" alt="This library helped you? Consider sponsoring!" src=".github/funding-octocat.svg">
</a>

# Blurhash

> 🖼️ Give your users the loading experience they want.

Install via [npm](https://www.npmjs.com/package/react-native-blurhash):

```sh
npm i react-native-blurhash
npx pod-install
```

[![npm](https://img.shields.io/npm/v/react-native-blurhash?color=%238B83E6)](https://www.npmjs.com/package/react-native-blurhash)
[![npm](https://img.shields.io/npm/dt/react-native-blurhash?color=%238B83E6)](https://www.npmjs.com/package/react-native-blurhash)

[![GitHub followers](https://img.shields.io/github/followers/mrousavy?label=Follow%20%40mrousavy&style=social)](https://github.com/mrousavy?tab=followers)
[![Twitter Follow](https://img.shields.io/twitter/follow/mrousavy?label=Follow%20%40mrousavy&style=social)](https://twitter.com/mrousavy)

**BlurHash** is a compact representation of a placeholder for an image. Instead of displaying boring grey little boxes while your image loads, show a _blurred preview_ until the full image has been loaded.

> The algorithm was created by [woltapp/blurhash](https://github.com/woltapp/blurhash), which also includes an [algorithm explanation](https://github.com/woltapp/blurhash/blob/master/Algorithm.md).

<div align="center">
  <p align="center">
    <img align="center" src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/explanation.png" alt="Turn grey image boxes into colorful blurred images" width="70%">
  </p>
</div>

## Example Workflow

<table>
<tr>
<td width="55%">
<ol>
  In order to use the Blurhash component, you have to already have a Blurhash string. See the <a href="https://blurha.sh">blurha.sh</a> page to create example strings.

  This is how I use it in my project:

  <li>A user creates a post by calling a function on my server which expects a payload of an image and some post data (title, description, ...)</li>
  <li>The function on my server then</li>
  <ol>
    <li>generates a blurhash from the image in the payload using the <a href="https://github.com/woltapp/blurhash/tree/master/C">C encoder</a></li>
    <li>stores the post data (including the generated blurhash string) in my database</li>
    <li>uploads the image to a content delivery network (e.g. AWS)</li>
  </ol>
  <li>Now everytime a user loads a feed of posts from my database, I can immediately show a <code>&lt;Blurhash&gt;</code> component (with the post's <code>.blurhash</code> property) over my <code>&lt;Image&gt;</code> component, and fade it out once the <code>&lt;Image&gt;</code> component's <a href="https://reactnative.dev/docs/image#onloadend"><code>onLoadEnd</code></a> function has been called.</li>
  
  <br/>
  <blockquote>
  Note: You can also use the <a href="#encoding">react-native-blurhash encoder</a> to encode straight from your React Native App!
  </blockquote>
</td>
<td width="25%">
<img src="https://github.com/mrousavy/react-native-blurhash/raw/master/img/demo.gif">
</td>
</tr>
</table>

## Usage

The `<Blurhash>` component has the following properties:

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
    <td><code>() => void</code></td>
    <td>A callback to call when the Blurhash started to decode the given <code>blurhash</code> string.</td>
    <td>❌</td>
    <td><code>undefined</code></td>
  </tr>
  <tr>
    <td><code>onLoadEnd</code></td>
    <td><code>() => void</code></td>
    <td>A callback to call when the Blurhash successfully decoded the given <code>blurhash</code> string and rendered the image to the <code>&lt;Blurhash&gt;</code> view.</td>
    <td>❌</td>
    <td><code>undefined</code></td>
  </tr>
  <tr>
    <td><code>onLoadError</code></td>
    <td><code>(message?: string) => void</code></td>
    <td>A callback to call when the Blurhash failed to load. Use the <code>message</code> parameter to get the error message.</td>
    <td>❌</td>
    <td><code>undefined</code></td>
  </tr>
  <tr>
    <td>All <code>View</code> props</td>
    <td><code>ViewProps</code></td>
    <td>All properties from the React Native <code>View</code>. Use <code>style.width</code> and <code>style.height</code> for display-sizes. Also, <code>style.borderRadius</code> is natively supported on iOS.</td>
    <td>❌</td>
    <td><code>{}</code></td>
  </tr>
</table>

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

### Average Color

If your app is **really colorful** you might want to match some containers' colors to the content's context. To achieve this, use the `getAverageColor` function to get an RGB value which represents the average color of the given Blurhash:

```ts
const averageColor = Blurhash.getAverageColor('LGFFaXYk^6#M@-5c,1J5@[or[Q6.')
```

### Encoding

This library also includes a **native Image encoder**, so you can **encode** Images to blurhashes straight out of your React Native App!

```ts
const blurhash = await Blurhash.encode('https://blurha.sh/assets/images/img2.jpg', 4, 3)
```

Because encoding an Image is a pretty heavy task, this function is **non-blocking** and runs on a separate background Thread.

### Validation

If you need to validate a blurhash string, you can use `isValidBlurhash`.

```ts
const result = Blurhash.isValidBlurhash('LGFFaXYk^6#M@-5c,1J5@[or[Q6.')
if (result.isValid) {
  console.log(`Blurhash is valid!`)
} else {
  console.log(`Blurhash is invalid! ${result.reason}`)
}
```

## Performance

The performance of the decoders is really fast, which means you should be able to use them in collections quite easily. By increasing the `decodeWidth` and `decodeHeight` props, the _time to decode_ also increases. I'd recommend values of `16` for large lists, and `32` otherwise. Play around with the values but keep in mind that you probably won't see a difference when increasing it to anything above `32`.

### Asynchronous Decoding

Use `decodeAsync={true}` to decode the Blurhash on a separate background Thread instead of the main UI-Thread. This is useful when you are experiencing stutters because of the Blurhash's **decoder** - e.g.: in large Lists.

Threads are re-used (iOS: `DispatchQueue`, Android: kotlinx Coroutines).

### Caching

#### Image

A `<Blurhash>` component caches the rendered Blurhash (Image) as long as the `blurhash`, `decodeWidth`, `decodeHeight` and `decodePunch` properties stay the same. Because unmounting the `<Blurhash>` component clears the cache, re-mounting it will cause it to decode again.

#### Cosine Operations

Cosine operations get cached in memory to avoid expensive re-calculation (~24.576 `cos(...)` calls per 32x32 blurhash). Since this can affect memory usage, you can manually clear the cosine array cache by calling:

```ts
Blurhash.clearCosineCache()
```

> Note: At the moment, cosine operations are only cached on Android. Calling `clearCosineCache()` is a no-op on other platforms.

## Resources
* [this medium article.](https://teabreak.e-spres-oh.com/swift-in-react-native-the-ultimate-guide-part-2-ui-components-907767123d9e) jesus christ amen thanks for that
* [Native Modules documentation](https://reactnative.dev/docs/native-modules-ios.html), especially the [Swift part](https://reactnative.dev/docs/native-modules-ios.html#exporting-swift)
* [This cheatsheet gist](https://gist.github.com/chourobin/f83f3b3a6fd2053fad29fff69524f91c) thank you [**@chourobin**](https://github.com/chourobin).
* [DylanVann/react-native-fast-image](https://github.com/DylanVann/react-native-fast-image) as a reference for native UI modules
* [woltapp/blurhash](https://github.com/woltapp/blurhash) of course


<a href='https://ko-fi.com/F1F8CLXG' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
