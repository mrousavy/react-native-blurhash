# Blurhash Example

This is an example app, demonstrating the usage of the [react-native-blurhash](https://github.com/mrousavy/react-native-blurhash) library.

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

To get started, run the following commands:

```sh
git clone https://github.com/mrousavy/react-native-blurhash
cd react-native-blurhash/example
yarn
rm -rf node_modules/react-native-blurhash/node_modules
cd ios; pod install; cd ..
npm run ios
npm run android
```

If you're trying to fix or implement something, I'd recommend you edit the library in this directory, since `node_modules/react-native-blurhash` is a symbolic link to `../`.

### iOS

1. Install Xcode
2. Open `ios/example.xcworkspace` in Xcode.
3. The react-native-blurhash library can be found when expanding the **Pods**/**Development Pods**/**react-native-blurhash** tree in the file view (left).

### Android

1. Install Android Studio
2. Open `android/` in Android Studio (example project)
3. Open `../` in Android Studio (react-native-blurhash)

### Good to know

1. On iOS, I couldn't get the compiler/resolver to find the React libraries when I opened the library's Xcode project. That's why I used the `example/` Project and edited **Pods**/**Development Pods**/**react-native-blurhash**.
3. When the `node_modules` folder of the `react-native-blurhash` library is not removed, all kinds of weird React errors pop up. Make sure you delete this first!
