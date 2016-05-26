/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import CryptoJS from 'crypto-js';
import AV from 'avoscloud-sdk'

//参数依次为 AppId, AppKey
AV.initialize('1RqTKwrmz8mdN7T363hYr5EE-gzGzoHsz', 'nVnctcogLY34o0sXcXvdiKd5');
console.log("AV.initialize");

// var TestObject = AV.Object.extend('TestObject');
// var testObject = new TestObject();
// testObject.save({
//   words: 'Hello World!'
// }, {
//   success: function(object) {
//     alert('LeanCloud Rocks!');
//   }
// });
// console.log("AV.TestObject");

class FlashWord extends Component {
  render() {
    console.log(CryptoJS.MD5('gasgasd').toString());
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
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

AppRegistry.registerComponent('FlashWord', () => FlashWord);
