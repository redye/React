'use strice'

import React, { 
    PureComponent,
    PropTypes
} from 'react';

import {
    requireNativeComponent,
    NativeModules,
} from 'react-native';
import ViewPropTypes from 'ViewPropTypes';


const CarouselViewNativeComponent = requireNativeComponent("CarouselView", CarouselView);

export default class CarouselView extends PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        let carouselView = (
            <CarouselViewNativeComponent
                {...this.props}
                onSelect={this._onSelect}
            />
        );
        return carouselView;
    }

    // MARK: 原生回调
    _onSelect = (event) => {
        let { index } = event.nativeEvent;
        this.props.onSelect && this.props.onSelect(index);
    }
}

CarouselView.propTypes = {
    ...ViewPropTypes,
    onSelect: PropTypes.func,
    dotColor: PropTypes.string,
    dotActiveColor: PropTypes.string,
    names: PropTypes.array,
    urls: PropTypes.array,
}