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
                                        textAlign: 'end',
                                        autoCorrect: false,
                                        autoCapitalize: 'none',
                                        onChangeText: this.codeChanged.bind(this)}),
        React.createElement(TouchableHighlight, {style:styles.button,
                                                 onPress: this.buttonClicked.bind(this),
                                                 underlayColor: '#aabbee'},
          React.createElement(Text, {style: styles.buttonText}, 'Reload')),
        React.createElement(View, {style:styles.fill})));
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
    flex:1,
    fontFamily: 'Courier New',
    fontSize:16,
    textAlign:'left',
    height: 100,
    borderColor: 'gray',
    borderWidth: 1,
    margin:10,
    marginTop: 20,
    padding:5
  },
  instructions: {
    textAlign:'center',
    color:'#333333',
    marginBottom:5
  },
  button: {
    marginBottom: 7
  },
  buttonText: {
    fontFamily: '.HelveticaNeueInterface-MediumP4',
    fontSize: 17,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#007aff'
  },
  fill: {
    height: 220
  }
});

AppRegistry.registerComponent('MyFirstApp', function(){return MyFirstApp;});
