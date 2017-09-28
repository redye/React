'use strict';

import React, {PureComponent} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
} from 'react-native';

export default class App extends PureComponent {
    render() {
        return (
        <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
            <Text>hello world</Text>
        </View>
        );
    }
}