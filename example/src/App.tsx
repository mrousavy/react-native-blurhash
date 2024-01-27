import React, {useCallback, useState, useMemo} from 'react';
import {
  StyleSheet,
  View,
  Text,
  TextInput,
  Switch,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  StatusBar,
  SafeAreaView,
} from 'react-native';
import {Blurhash} from 'react-native-blurhash';

const COLORS = {
  background: '#F5FCFF',
  statusBar: 'rgba(100, 0, 100, 0.6)',
  textInput: 'rgba(200, 0, 100, 0.5)',
  button: 'rgba(200, 0, 100, 0.4)',
  switchEnabled: 'rgba(200, 0, 100, 0.5)',
  switchDisabled: 'rgba(200, 0, 100, 0.2)',
  switchThumb: 'white',
  shadow: 'black',
};
const SWITCH_THUMB_COLORS = {
  false: COLORS.switchDisabled,
  true: COLORS.switchEnabled,
};

export default function App() {
  //#region State & Props
  const [blurhash, setBlurhash] = useState('LGFFaXYk^6#M@-5c,1J5@[or[Q6.');
  const [decodeAsync, setDecodeAsync] = useState(true);
  const [encodingImageUri, setEncodingImageUri] = useState(
    'https://github.com/woltapp/blurhash/blob/master/Website/assets/images/img1.jpg?raw=true',
  );
  const [isEncoding, setIsEncoding] = useState(false);
  //#endregion

  //#region Memos
  const buttonOpacity = useMemo(
    () => (encodingImageUri.length < 5 || isEncoding ? 0.5 : 1),
    [encodingImageUri.length, isEncoding],
  );
  const encodeButtonStyle = useMemo(
    () => [styles.encodeButton, {opacity: buttonOpacity}],
    [buttonOpacity],
  );
  //#endregion

  //#region Callbacks
  const onLoadStart = useCallback(() => {
    console.log('onLoadStart called!');
  }, []);
  const onLoadEnd = useCallback(() => {
    console.log('onLoadEnd called!');
  }, []);
  const onLoadError = useCallback((message?: string) => {
    console.log(`onLoadError called! Message: ${message}`);
  }, []);
  const startEncoding = useCallback(async () => {
    try {
      if (encodingImageUri.length < 5) return;

      setIsEncoding(true);
      const _blurhash = await Blurhash.encode(encodingImageUri, 4, 3);
      setBlurhash(_blurhash);
      setIsEncoding(false);
    } catch (e: any) {
      setIsEncoding(false);
      console.warn('Failed to encode!', e);
      Alert.alert('Encoding error', e.message);
    }
  }, [encodingImageUri]);
  //#endregion

  return (
    <>
      <StatusBar backgroundColor={COLORS.statusBar} />
      <SafeAreaView style={styles.container}>
        <View style={styles.blurhashContainer}>
          <View style={styles.blurhashRadiusMask}>
            <Blurhash
              blurhash={blurhash}
              decodeWidth={32}
              decodeHeight={32}
              decodePunch={1}
              decodeAsync={decodeAsync}
              onLoadStart={onLoadStart}
              onLoadEnd={onLoadEnd}
              onLoadError={onLoadError}
              style={styles.blurhashImage}
              resizeMode="cover"
            />
          </View>
        </View>
        <TextInput
          value={blurhash}
          placeholder="Blurhash"
          onChangeText={setBlurhash}
          style={styles.textInput}
        />
        {/* To test if `decodeAsync` really doesn't block the UI thread, you can press this Touchable and see it reacting. */}
        <View style={styles.row}>
          <Text style={styles.text}>Decode Async:</Text>
          <Switch
            thumbColor={COLORS.switchThumb}
            trackColor={SWITCH_THUMB_COLORS}
            ios_backgroundColor={COLORS.switchDisabled}
            value={decodeAsync}
            onValueChange={setDecodeAsync}
          />
        </View>
        <TextInput
          value={encodingImageUri}
          placeholder="Image URL to encode"
          onChangeText={setEncodingImageUri}
          style={styles.textInput}
        />
        <TouchableOpacity
          style={encodeButtonStyle}
          disabled={encodingImageUri.length < 5}
          onPress={startEncoding}>
          {isEncoding ? (
            <ActivityIndicator color="black" />
          ) : (
            <Text>Encode</Text>
          )}
        </TouchableOpacity>
      </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: COLORS.background,
  },
  blurhashContainer: {
    shadowRadius: 3,
    shadowColor: COLORS.shadow,
    shadowOffset: {
      height: 2,
      width: 0,
    },
    shadowOpacity: 0.4,
    overflow: 'visible',
  },
  blurhashRadiusMask: {
    elevation: 5,
    // borderRadius has to be applied to the parent
    borderRadius: 5,
    overflow: 'hidden',
  },
  blurhashImage: {
    width: 300,
    height: 200,
    // Custom styling for width, height, scaling etc here
  },
  textInput: {
    marginTop: 20,
    borderRadius: 5,
    borderWidth: 1,
    borderColor: COLORS.textInput,
    width: '70%',
    height: 35,
    paddingHorizontal: 20,
    textAlign: 'center',
  },
  row: {
    marginTop: 30,
    flexDirection: 'row',
    alignItems: 'center',
  },
  text: {
    fontSize: 16,
    marginRight: 15,
  },
  encodeButton: {
    height: 37,
    width: 120,
    marginTop: 30,
    backgroundColor: COLORS.button,
    borderRadius: 10,
    paddingVertical: 10,
    paddingHorizontal: 35,
    justifyContent: 'center',
  },
});
