import React, {
    PureComponent,
    PropTypes
} from 'react';
import {
    requireNativeComponent,
} from 'react-native';
import ViewPropTypes from 'ViewPropTypes';
import CarsouselView from './WFWebView';

export default class CarsouselView extends PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        return <CarsouselView
            ref={(c) => this.carouselView = }
            {...this.props}
        />;
    }
}

CarsouselView.propTypes = {
    ...ViewPropTypes,
    onSelect: PropTypes.func,
    dotColor: PropTypes.string,
    dotActiveColor: PropTypes.string,
    names: PropTypes.array,
    urls: PropTypes.array,
};