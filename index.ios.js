'use strict';

var React = require('react-native/Libraries/react-native/react-native.js');

var AppRegistry = React.AppRegistry;
var StyleSheet = React.StyleSheet;
var Text = React.Text;
var View = React.View;
var TextInput = React.TextInput;
var TouchableHighlight = React.TouchableHighlight;
var AsyncStorage = React.AsyncStorage;
var ScrollView = React.ScrollView;
var Picker = React.PickerIOS;
var PickerItem = Picker.Item;

var Spawner = require('react-native/Libraries/react-native/react-native.js').NativeModules.Spawner;

var MyFirstApp = React.createClass({
  displayName: 'MyFirstApp',
  getInitialState: function() {
    return {text: "", versions: [1,2,3],
            pickerVersion: 1,
            loadedVersion: 0};
  },
  buttonClicked: function() {
    Spawner.spawn(this.state.text);
  },
  codeChanged: function(text) {
    this.setState({text: text});
  },
  componentWillMount: function() {
    Spawner.currentVersion(function(version){
      this.setState({pickerVersion: version});
    }.bind(this));
    Spawner.loadedVersion(function(version){
      this.setState({loadedVersion: version});
    }.bind(this));
    Spawner.versions(function(versions){
      this.setState({versions: versions});
    }.bind(this));

    Spawner.curentSource(this.curentSource);
  },
  curentSource: function(error, source) {
    this.setState({text: source});
  },
  versionChanged: function(version){
    this.setState({pickerVersion: version});
    Spawner.source(version,function(error,code){
      this.setState({text: code});
    }.bind(this));
  },
  doneClicked: function() {
    this.refs.code.blur();
  },
  render:      function(){
    var versions = this.state.versions.map(function(version){
      return React.createElement(PickerItem, {
        key: version,
        value: version,
        label: "Version "+version});
    });
    return (
      React.createElement(View, {style:styles.container},
        React.createElement(ScrollView, {style:styles.scroll,
 horizontal:true,
 keyboardShouldPersistTaps: true}, React.createElement(TextInput, {style:styles.codeInput,
                                        value: this.state.text,
                                        multiline: true,
                                        textAlign: 'end',
                                        autoCorrect: false,
                                        autoCapitalize: 'none',
                                        onChangeText: this.codeChanged,
                                        ref: 'code'})),
        React.createElement(View, {style: styles.tray},
          [React.createElement(Text, {style: styles.vText}, 'v.'+this.state.loadedVersion),
          React.createElement(TouchableHighlight, {style:styles.button,
                                                 onPress: this.doneClicked,
                                                 underlayColor: '#aabbee'},
            React.createElement(Text, {style: styles.buttonText}, 'Hide Keyboard')),
          React.createElement(TouchableHighlight, {style:styles.button,
                                                 onPress: this.buttonClicked,
                                                 underlayColor: '#aabbee'},
            React.createElement(Text, {style: styles.buttonText}, 'Run!'))
          ]),
        React.createElement(Picker,{style: styles.picker,
                                    selectedValue: this.state.pickerVersion,
                                    onValueChange: this.versionChanged},versions),
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
  scroll: {
    flex:1,
    width: 375
  },
  codeInput: {
    width: 1000,
    height: 3000,
    fontFamily: 'Courier New',
    fontSize:16,
    textAlign:'left',
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
    margin: 20,
    marginTop: 0,
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
    height: 0
  },
  picker: {
    height: 210,
    width: 375
  },
  tray: {
    flexDirection: 'row'
  },
  vText: {
    fontFamily: '.HelveticaNeueInterface-MediumP4',
    fontSize: 17,
    width: 80,
    textAlign: 'left',
  }
});

AppRegistry.registerComponent('MyFirstApp', function(){return MyFirstApp;});
