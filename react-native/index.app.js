/**
 * Created by aaron on 17/2/27.
 */
import{
    AppRegistry
} from 'react-native';

/**
 * 控制台打印语句可能会极大地拖累JavaScript线程
 */
if (!__DEV__) {
  console = {
    info: () => {},
    log: () => {},
    warn: () => {},
    error: () => {},
  };
}


import App from './app/App';

AppRegistry.registerComponent('App', () => App);
