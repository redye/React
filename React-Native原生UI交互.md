## React-Native原生UI交互
react-native 的使用现在越来越广泛，优秀的第三方组件也层出不穷，有纯 JS 的，也有依赖原生组件的，当然，纯 JS 的组件在应用上更为简便，不需要考虑平台，但也有些是纯靠 JS 做不到，则会考虑从原生导出，今天要讲的就是从原生导出 UI 组件。

今天以一个图片轮播 `YHCarouselView` 组件为例，首先是为自己的学习做一个记录，然后希望能够帮到正在学习的你。

### 准备工作
图片轮播是以前闲暇之余封装好的一个组件，功能简单，简单易用，支持本地图片和网络图片，[链接](https://github.com/redye/YHViewKit)里有 OC 版本和 Swift 版本。这里先献上本地使用的效果图。

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

> `RCT_EXPORT_MODULE` 可以传入参数，指定该 module 的名字，也可以不传递参数，默认使用该 module 的类名，若 module 名以 `Manager` 为后缀，则取后缀后的字符串为名字；若 module 名以 `RCT` 或 `RK` 为前缀，则会取去前缀后的字符串为名字。
> 
> `+ (void)load`：  该方法在内存中只会调用一次，且只会在第一次调用该类时调用。
