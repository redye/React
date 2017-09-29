//
//  YHImageView.h
//  KitDemo
//
//  Created by Hu on 16/8/1.
//  Copyright © 2016年 redye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHCarouselView;
@protocol YHCarouselViewDelegate <NSObject>

@optional
- (void)carouselView:(YHCarouselView *)carouselView didSelectedAtIndex:(NSUInteger)index;
/**
 *  代理方法，当图片需要下载时需要实现这个代理方法，同事必须给 imageCount 属性赋值
 *
 *  @param carouselView 轮播视图
 *  @param index        当前展示的图片索引
 *  @param imageView    当前展示图片的容器
 */
- (void)carouselView:(YHCarouselView *)carouselView didShowAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView;

@end

@interface YHCarouselView : UIView

@property (nonatomic, weak) id<YHCarouselViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger imageCount; // 如果使用图片下载时，这个属性必须实现 

/**
 *  设置页面指示的默认颜色
 *
 *  @param color 颜色
 */
- (void)setIndicatorColor:(UIColor *)color;

/**
 *  设置当前页面指示的颜色
 *
 *  @param color 颜色
 */
- (void)setCurrentIndicatorColor:(UIColor *)color;

/**
 *  加载图片，以图片名称的方式
 *
 *  @param imageNames 图片名称
 */
- (void)loadImageNames:(NSArray *)imageNames;
@end
