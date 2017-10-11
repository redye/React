'use strict';

import React, {PureComponent} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,

} from 'react-native';

import Dimensions from 'Dimensions';

const screenWidth = Dimensions.get('window').width;
const screenHeight = Dimensions.get('window').height;


import CarouselView from './component/CarouselView';

export default class App extends PureComponent {

    constructor(props) {
        super(props);

        this.imageUrls = [
            "http://a.hiphotos.baidu.com/zhidao/pic/item/72f082025aafa40fa38bfc55a964034f79f019ec.jpg",
            "http://photo.enterdesk.com/2011-2-16/enterdesk.com-1AA0C93EFFA51E6D7EFE1AE7B671951F.jpg",
            "http://dl.bizhi.sogou.com/images/2012/09/30/44928.jpg",
            "http://dl.bizhi.sogou.com/images/2012/03/08/96703.jpg",
            "http://image.tianjimedia.com/uploadImages/2012/010/XC4Y39BYZT9A.jpg",
            "http://pic51.nipic.com/file/20141030/2531170_080422201000_2.jpg"
        ];

        this.imageNames = [
            "IMG_0010.JPG",
            "IMG_0021.JPG",
            "IMG_0023.JPG",
            "IMG_0149.JPG",
            "IMG_0151.JPG",
            "IMG_0166.JPG"
        ];
    }

    render() {
        return (
        <View style={styles.container}>
            <View style={{marginTop: 100, alignItems: 'center'}}>
                <Text style={{marginBottom: 10}}>本地图片</Text>
                <CarouselView 
                    style={styles.carouselView} 
                    dotColor='#ff0000'
                    dotActiveColor='#00ff00'
                    names={this.imageNames}
                    onSelect={this._onSelect}
                    title='title'
                    subtitle='subtitle'
                    ref={(c) => this._carouselView = c}
                />
            </View>

            <View style={{marginTop: 30, alignItems: 'center'}}>
                <Text style={{marginBottom: 10}}>网络图片</Text>
                <CarouselView 
                    style={styles.carouselView} 
                    dotColor='#999999'
                    dotActiveColor='#ffffff'
                    urls={this.imageUrls}
                    onSelect={this._onSelect2}
                />
            </View>
            
        </View>
        );
    }

    _onSelect = (index) => {
        console.log('index ======>', index);
        if (this._carouselView) {
            this._carouselView.setNativeProps({
                title: null
            });
        }
    }

    _onSelect2 = (index) => {
        console.log('index ======>', index);
        if (this._carouselView) {
            this._carouselView.setNativeProps({
                title: 'null'
            });
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1, 
        alignItems: 'center'
    },
    carouselView: {
        width:screenWidth,
        height: 200 
    }
});