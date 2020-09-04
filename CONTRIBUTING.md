## Contributing to react-native-blurhash

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

I initially created the library because I wanted to create a rich experience for the startup app I'm building, [Springsale](https://github.com/Springsale). 
As **react-native-blurhash** gained more and more stargazers, I added more and more features to this library such as [encoding support](https://github.com/mrousavy/react-native-blurhash#encoding), asynchronous decoding, load status callbacks, [windows support](https://github.com/mrousavy/react-native-blurhash/issues/41) and more.

### What you need to know

1. The native iOS part is written in Swift and bridged to Objective-C (for the React-Native macros). If you're not familiar with this setup, either read into the code, or check out the [resources](https://github.com/mrousavy/react-native-blurhash#resources) I used.
    1. The blurhash **encoder** and **decoder** is copied from [woltapp/blurhash/Swift](https://github.com/woltapp/blurhash/tree/master/Swift) as per commit [95d05e2](https://github.com/woltapp/blurhash/commit/95d05e2f639db8086c1b8bc53092a4cf5c14924b) and uses [this PR](https://github.com/woltapp/blurhash/pull/80) to cache Cosine operations
2. The native Android part is written in Kotlin. If you're not familiar with this setup, read some Kotlin syntax and you'll get the hang of it.
    1. The blurhash **decoder** is copied from [woltapp/blurhash/Kotlin](https://github.com/woltapp/blurhash/tree/master/Kotlin/lib/src/main/java/com/wolt/blurhashkt) as per commit [539cf8a](https://github.com/woltapp/blurhash/commit/539cf8a5425d766227b52e1d487a231bc5c7b72e)
    2. The blurhash **encoder** is copied from [this PR](https://github.com/woltapp/blurhash/pull/55)
3. The JS part is written in JS, and types are manually created using an `index.d.ts` file.
4. Currently the `BlurhashView` type inherits from `UIView` (iOS) and `AppCompatImageView` (Android). That means, they are different types, and none of those inherits from `RCTImageView`/`ReactImage`. (Mostly because on Android the `setDrawable(...)` fucntion is deprecated when inheriting from `ReactImage` since it uses `source` for setting the Image source)


### Code Style

1. For Swift, use [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
2. For Kotlin, use Android Studio
3. For JS, use ESLint and Prettier (already configured in the Project)

### Pull Requests

Create pull requests if:

* You added some stuff that enhances the library
* You added some stuff that fixes a bug in the library
* You changed some stuff so the library is more efficient (is _faster_)

### Issues

Create issues if:

* Something doesn't work as expected
* You have a question (use the _Question_ issue template)
* You want to propose changes or enhancements to the library


### Extra

Always stay civil in discussions. Otherwise I'll find you
