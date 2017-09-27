# React

[![CI Status](http://img.shields.io/travis/408939786@qq.com/WFWebView.svg?style=flat)](https://travis-ci.org/408939786@qq.com/WFWebView)
[![Version](https://img.shields.io/cocoapods/v/WFWebView.svg?style=flat)](http://cocoapods.org/pods/WFWebView)

## 制作过程

```
{
	"name": "Loan",
	"version": "1.0.0",
	"private": true,
	"scripts": {
	},
	"dependencies": {
		"react": "15.5.4",
		"react-native": "0.42.0",
	}
}
```
安装完node之后，取react-native文件夹中所有文件，复制到当前目录下，然后修改React.podspec文件中的版本号和source，其中podspec文件需要手动复制到spec中，并且复制react-native文件中的package.json文件夹。
##0.44.3
```
  react_version = '0.44.3'
  pod 'Yoga', "#{react_version}.React"
  pod 'React/Core', "#{react_version}"
  pod 'React/DevSupport', "#{react_version}"
  pod 'React/RCTImage', "#{react_version}"
  pod 'React/RCTNetwork', "#{react_version}"
  pod 'React/RCTText', "#{react_version}"
  pod 'React/RCTWebSocket', "#{react_version}"
  pod 'React/RCTAnimation', "#{react_version}"

```
##0.42.0
```
  react_version = '0.42.0'
  pod 'Yoga', "#{react_version}.React"
  pod 'React/Core', "#{react_version}"
  pod 'React/RCTImage', "#{react_version}"
  pod 'React/RCTNetwork', "#{react_version}"
  pod 'React/RCTText', "#{react_version}"
  pod 'React/RCTWebSocket', "#{react_version}"
  pod 'React/RCTAnimation', "#{react_version}"

```
