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
  ScrollView,
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
  cardBackground: 'white',
  cardShadow: 'rgba(0, 0, 0, 0.1)',
  title: '#333',
  subtitle: '#666',
};
const SWITCH_THUMB_COLORS = {
  false: COLORS.switchDisabled,
  true: COLORS.switchEnabled,
};

const EXAMPLE_BLURHASHES = [
  {
    id: '1',
    title: 'Example 1',
    blurhash: 'LGFFaXYk^6#M@-5c,1J5@[or[Q6.',
    description: 'Example 1',
  },
  {
    id: '2',
    title: 'Example 2',
    blurhash: 'LKO2?U%2Tw=w]~RBVZRi};RPxuwH',
    description: 'Example 2',
  },
  {
    id: '3',
    title: 'Example 3',
    blurhash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.',
    description: 'Example 3',
  },
  {
    id: '4',
    title: 'Example 4',
    blurhash: 'L6PZfSi_.AyE_3t7t7R**0o#DgR4',
    description: 'Example 4',
  },
  {
    id: '5',
    title: 'Example 5',
    blurhash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.',
    description: 'Example 5',
  },
];

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
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}>
          <Text style={styles.headerTitle}>Blurhash Examples</Text>
          <Text style={styles.headerSubtitle}>
            Scroll to see different blurhash examples
          </Text>

          {EXAMPLE_BLURHASHES.map((example) => (
            <View key={example.id} style={styles.card}>
              <Text style={styles.cardTitle}>{example.title}</Text>
              <Text style={styles.cardDescription}>{example.description}</Text>
              <View style={styles.blurhashContainer}>
                <View style={styles.blurhashRadiusMask}>
                  <Blurhash
                    blurhash={example.blurhash}
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
              <Text style={styles.blurhashText} numberOfLines={1}>
                {example.blurhash}
              </Text>
            </View>
          ))}

          <View style={styles.card}>
            <Text style={styles.cardTitle}>Custom Blurhash</Text>
            <Text style={styles.cardDescription}>
              Enter your own blurhash string
            </Text>
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
              placeholder="Enter blurhash string"
              onChangeText={setBlurhash}
              style={styles.textInput}
            />
          </View>

          <View style={styles.card}>
            <Text style={styles.cardTitle}>Encode Image</Text>
            <Text style={styles.cardDescription}>
              Convert an image URL to blurhash
            </Text>
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
                <ActivityIndicator color="white" />
              ) : (
                <Text style={styles.buttonText}>Encode Image</Text>
              )}
            </TouchableOpacity>
          </View>

          <View style={styles.settingsCard}>
            <Text style={styles.cardTitle}>Settings</Text>
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
            <Text style={styles.settingsDescription}>
              Enable async decoding to prevent UI blocking
            </Text>
          </View>
        </ScrollView>
      </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 32,
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: COLORS.title,
    marginBottom: 8,
    textAlign: 'center',
  },
  headerSubtitle: {
    fontSize: 14,
    color: COLORS.subtitle,
    marginBottom: 24,
    textAlign: 'center',
  },
  card: {
    backgroundColor: COLORS.cardBackground,
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    shadowColor: COLORS.cardShadow,
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },
  settingsCard: {
    backgroundColor: COLORS.cardBackground,
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    shadowColor: COLORS.cardShadow,
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },
  cardTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: COLORS.title,
    marginBottom: 4,
  },
  cardDescription: {
    fontSize: 14,
    color: COLORS.subtitle,
    marginBottom: 12,
  },
  blurhashContainer: {
    shadowRadius: 4,
    shadowColor: COLORS.shadow,
    shadowOffset: {
      height: 2,
      width: 0,
    },
    shadowOpacity: 0.2,
    overflow: 'visible',
    marginBottom: 12,
  },
  blurhashRadiusMask: {
    elevation: 5,
    borderRadius: 8,
    overflow: 'hidden',
  },
  blurhashImage: {
    width: '100%',
    height: 200,
  },
  blurhashText: {
    fontSize: 12,
    color: COLORS.subtitle,
    fontFamily: 'monospace',
    marginTop: 8,
  },
  textInput: {
    marginTop: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: COLORS.textInput,
    height: 44,
    paddingHorizontal: 16,
    fontSize: 14,
    backgroundColor: COLORS.background,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  text: {
    fontSize: 16,
    color: COLORS.title,
  },
  settingsDescription: {
    fontSize: 12,
    color: COLORS.subtitle,
    marginTop: 8,
    fontStyle: 'italic',
  },
  encodeButton: {
    height: 44,
    marginTop: 16,
    backgroundColor: COLORS.button,
    borderRadius: 8,
    paddingVertical: 12,
    paddingHorizontal: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
});
