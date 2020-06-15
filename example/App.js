/**
 * Sample React Native App
 *
 * adapted from App.js generated by the following command:
 *
 * react-native init example
 *
 * https://github.com/facebook/react-native
 */

import React, {Component} from 'react';
import {StyleSheet, View, TextInput} from 'react-native';
import {Blurhash} from 'react-native-blurhash';

export default class App extends Component {
  state = {
    blurhash: 'LGFFaXYk^6#M@-5c,1J5@[or[Q6.',
  };
  componentDidMount() {}

  render() {
    return (
      <View style={styles.container}>
        <Blurhash
          blurhash={this.state.blurhash}
          decodeWidth={16}
          decodeHeight={16}
          decodePunch={1}
          style={styles.blurhashImage}
        />
        <TextInput
          value={this.state.blurhash}
          placeholder="Blurhash"
          onChangeText={(text) => {
            this.setState({
              blurhash: text,
            });
          }}
          style={styles.blurhashTextInput}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  blurhashImage: {
    width: 300,
    height: 200,
    // Custom styling for width, height, scaling etc here
  },
  blurhashTextInput: {
    marginTop: 20,
    borderRadius: 5,
    borderWidth: 1,
    borderColor: 'purple',
    width: '70%',
    height: 35,
    paddingHorizontal: 20,
    textAlign: 'center',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
