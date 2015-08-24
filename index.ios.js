'use strict';

var React=require('react-native/Libraries/react-native/react-native.js');

var AppRegistry = React.AppRegistry;
var StyleSheet = React.StyleSheet;
var Text = React.Text;
var View = React.View;

var MyFirstApp = React.createClass({
  displayName: 'MyFirstApp',
  render:      function(){
    return (
      React.createElement(View, {style:styles.container},
        React.createElement(Text, {style:styles.welcome}, 'Welcome to your doom!'),
        React.createElement(Text, {style:styles.instructions}, 'To get started, edit index.ios.js'),
        React.createElement(Text, {style:styles.instructions}, 'Press Cmd+R to reload,', '\n', 'Cmd+D or shake for dev menu')));
  }
});

var styles = StyleSheet.create({
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

var styles = StyleSheet.create({
  container: {
    flex:1,
    justifyContent:'center',
    alignItems:'center',
    backgroundColor:'#F5FCFF'
  },
  welcome: {
    fontSize:20,
    textAlign:'center',
    margin:10
  },
  instructions: {
    textAlign:'center',
    color:'#333333',
    marginBottom:5
  }
});

AppRegistry.registerComponent('MyFirstApp', function(){return MyFirstApp;});
