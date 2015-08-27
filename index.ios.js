'use strict';

var React=require('react-native/Libraries/react-native/react-native.js');

var AppRegistry = React.AppRegistry;
var StyleSheet = React.StyleSheet;
var Text = React.Text;
var View = React.View;
var TextInput = React.TextInput;
var TouchableHighlight = React.TouchableHighlight;

var Spawner = require('react-native').NativeModules.Spawner;


var MyFirstApp = React.createClass({
  displayName: 'MyFirstApp',
  getInitialState: function() {
    return {text: "Replace me"};
  },
  buttonClicked: function() {
    Spawner.spawn(this.state.text);
  },
  codeChanged: function(text) {
    this.setState({text: text});
  },
  render:      function(){
    return (
      React.createElement(View, {style:styles.container},
        React.createElement(TextInput, {style:styles.welcome,
                                        value: this.state.text,
                                        multiline: true,
                                        onChangeText: this.codeChanged.bind(this)}),
        React.createElement(TouchableHighlight, {style:styles.button,
                                                 onPress: this.buttonClicked.bind(this)},
          React.createElement(Text, {}, 'Button!'))));
  }
});

var styles = StyleSheet.create({
  container: {
    flex:1,
    justifyContent:'center',
    alignItems:'center',
    backgroundColor:'#F5FCFF'
  },
  welcome: {
    fontSize:16,
    textAlign:'left',
    height: 100,
    borderColor: 'gray',
    borderWidth: 1,
    margin:10
  },
  instructions: {
    textAlign:'center',
    color:'#333333',
    marginBottom:5
  },
  button: {
    textAlign: 'center',
    color: '#ffffff',
    marginBottom: 7,
    borderRadius: 2,
    borderColor: '#0000ff',
    borderWidth: 1
  }
});

AppRegistry.registerComponent('MyFirstApp', function(){return MyFirstApp;});
