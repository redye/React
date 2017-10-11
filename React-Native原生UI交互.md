## React-Native原生UI交互
react-native 的使用现在越来越广泛，优秀的第三方组件也层出不穷，有纯 JS 的，也有依赖原生组件的，当然，纯 JS 的组件在应用上更为简便，不需要考虑平台，但也有些是纯靠 JS 做不到，则会考虑从原生导出，今天要讲的就是从原生导出 UI 组件。

今天以一个图片轮播 `YHCarouselView` 组件为例，首先是为自己的学习做一个记录，然后希望能够帮到正在学习的你。

### 准备工作
图片轮播是以前闲暇之余封装好的一个组件，功能简单，简单易用，支持本地图片和网络图片，[链接](https://github.com/redye/YHViewKit)里有 OC 版本和 Swift 版本。这里先献上本地使用的效果图。

![native](https://github.com/redye/React/blob/master/native.gif)

### 导出组件
根据 react-native 的使用文档，导出 UI 组件，原生视图都需要被一个`RCTViewManager`的子类来创建和管理。这些管理器在功能上有些类似“视图控制器”，但它们本质上都是单例 —— React Native只会为每个管理器创建一个实例。它们创建原生的视图并提供给`RCTUIManager`，`RCTUIManager`则会反过来委托它们在需要的时候去设置和更新视图的属性。`RCTViewManager`还会代理视图的所有委托，并给JavaScript发回对应的事件。摘抄自 [React-Native中文网](http://reactnative.cn/docs/0.48/native-component-ios.html#content)。

导出 UI 组件三步走：

1. 创建一个子类
2. 添加 `RCT_EXPORT_MODULE()`标记宏
3. 实现 `-(UIView *)view` 方法

#### 创建一个子类
这很好理解，就是创建一个待导出组件（这里的带导出组件就是 `YHCarouselView`）的子类，这里可以对组件做进一步的封装，特别需要说明的是，如果该组件有回调需要处理，这里即必须用到 `RCTDirectEventBlock` 或者 `RCTBubblingEventBlock`，而且命名的时候要特别注意，需要已 `on` 开头，熟悉 JS 的朋友应该会反应过来，这很像 JS 的事件命名规范。

`YHCarouselView` 是有两个可选代理回调的，
		
	/**
 	代理方法，选择当前图片

 	@param carouselView 轮播视图
 	@param index 当前图片的索引
 	*/
	- (void)carouselView:(YHCarouselView *)carouselView didSelectedAtIndex:(NSUInteger)index;
	/**
 	*  代理方法，当图片需要下载时需要实现这个代理方法，同事必须给 imageCount 属性赋值
 	*
 	*  @param carouselView 轮播视图
 	*  @param index        当前展示的图片索引
 	*  @param imageView    当前展示图片的容器
 	*/
	- (void)carouselView:(YHCarouselView *)carouselView didShowAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView;
		
所以在做进一步封装的时候，需要提供以 `on` 开头的事件回调。

	@interface CarouselView : YHCarouselView

	@property (nonatomic, strong) NSString *dotColor;
	@property (nonatomic, strong) NSString *dotActiveColor;
	@property (nonatomic, strong) NSArray<NSString *> *names;
	@property (nonatomic, strong) NSArray<NSString *> *urls;
	@property (nonatomic, copy) RCTDirectEventBlock onSelect;
	
	@end

#### 添加 `RCT_EXPORT_MODULE()`标记宏
在 react-native 的世界里，所有的视图都是交给 `RCTViewManager` 来管理的，所以我们需要一个 `CarouselViewManager` 的类来管理 `CarouselView`，`CarouselViewManager` 继承自 `RCTViewManager`， `RCTViewManager` 实现 `RCTBridgeModule` 协议。
	
	#define RCT_EXPORT_MODULE(js_name) \
	RCT_EXTERN void RCTRegisterModule(Class); \
	+ (NSString *)moduleName { return @#js_name; } \
	+ (void)load { RCTRegisterModule(self); }
	
以上是 `RCT_EXPORT_MODULE()` 的完整定义，可以清楚的看到，该宏做了两件事：

* 定义该组件的名字。
* 注册该 `module`。

> * `RCT_EXPORT_MODULE` 可以传入参数，指定该 module 的名字，也可以不传递参数，默认使用该 module 的类名，若 module 名以 `Manager` 为后缀，则取后缀后的字符串为名字；若 module 名以 `RCT` 或 `RK` 为前缀，则会取去前缀后的字符串为名字。
> * `+ (void)load`：  该方法在内存中只会调用一次，且只会在程序调用期间调用一次。[你真的了解 load 方法么?](https://github.com/Draveness/analyze/blob/master/contents/objc/%E4%BD%A0%E7%9C%9F%E7%9A%84%E4%BA%86%E8%A7%A3%20load%20%E6%96%B9%E6%B3%95%E4%B9%88%EF%BC%9F.md)

#### 实现 `-(UIView *)view` 方法
在 `CarouselViewManager` 类的 `- (UIView *)view` 方法里返回视图，这个方法会初始化视图，需要注意的是，如果视图有代理回调，需要在这里处理。

	- (UIView *)view {
   		CarouselView *carouselView = [[CarouselView alloc] init];
   		carouselView.delegate = self;
   		return carouselView;		}
 
代理方法如果要暴露到 JS 的话，可以通过上面的 `onXxx` 属性。

	#pragma mark - YHCarouselViewDelegate
	- (void)carouselView:(CarouselView *)carouselView didSelectedAtIndex:(NSUInteger)index {    		
		if (carouselView.onSelect) {
      	 	carouselView.onSelect(@{@"index": @(index)});
   		}
	}
	
#### 导出属性
属性分为两种

* 视图已经存在的属性
* 在 `ViewManager` 中自定义的属性

#### 视图已经存在的属性
对于视图已经存在的属性，只需要使用 `React` 提供的宏 `RCT_EXPORT_VIEW_PROPERTY(name, type)`，第一个参数是该属性的名字，第二个参数是该属性的类型，这里的类型支持所有标准JSON类型：

* string (NSString)
* number (NSInteger, float, double, CGFloat, NSNumber)
* boolean (BOOL, NSNumber)
* array (NSArray) 包含本列表中任意类型
* object (NSDictionary) 包含string类型的键和本列表中任意类型的值
* function (RCTResponseSenderBlock)	

#### 自定义属性
自定义属性相对来说复杂一点，`React` 同样提供宏 `RCT_CUSTOM_VIEW_PROPERTY(name, type, viewClass)`，完整的属性定义为 

	#define RCT_CUSTOM_VIEW_PROPERTY(name, type, viewClass) \
	RCT_REMAP_VIEW_PROPERTY(name, __custom__, type)         \
	- (void)set_##name:(id)json forView:(viewClass *)view withDefaultView:(viewClass *)defaultView

`json` 代表了JS中传递的尚未解析的原始值。函数里还有一个 `view` 变量，使得我们可以访问到对应的视图实例
这里需要注意的是 `defaultView`， 当 JS 传入的是 `null` 时，即 `json` 值为空时，`defaultView` 才不为空，当 `defaultView` 一次不为空后，后续在传入的数据不管是否有值，都不会为 `nil`，可以看到 `defaultView` 上面的视图层次以及视图的属性值，都是最初的默认值。

![defaultView](https://github.com/redye/React/blob/master/defaultView.png)

### 在JS中使用组件
在 JS 中使用组件，首先需要让这个视图变成一个可用的React组件:

	import { requireNativeComponent } from 'react-native';
	
	// requireNativeComponent 自动把这个组件提供给 "CarouselViewManager"
	const CarouselViewNativeComponent = requireNativeComponent("CarouselView", CarouselView);

> `requireNativeComponent` 通常具有两个参数，第一个是本地视图的名称，第二个是描述组件接口的对象。组件接口应该声明一个友好的*名称*在调试消息中使用，并且必须声明本地视图所反映的 `propTypes`。`PropTypes` 用于检查用户使用本地视图的有效性。
	
对于 native 导出的组件都应该是 iOS 和 Android 相互独立的，在创作阶段，如果对两个平台都很熟悉的话，恭喜您一个人就可以搞定，但如果是像我只熟悉 iOS 平台的话，就需要另外一个熟悉 Android 的小伙伴帮忙了，并且对 JS 暴露的属性名称和方法约定好。

最后附上项目[地址](https://github.com/redye/React)以及 React 下的运行效果图。
![react](https://github.com/redye/React/blob/master/react.gif)