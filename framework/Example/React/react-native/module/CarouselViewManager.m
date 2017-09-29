//
//  CarouselViewManager.m
//  React
//
//  Created by redye.hu on 2017/9/29.
//  Copyright © 2017年 redye.hu. All rights reserved.
//

#import "CarouselViewManager.h"
#import "YHCarouselView.h"
#import "UIColor+Addition.h"
#import "UIImageView+WebCache.h"

@interface CarouselView : YHCarouselView<YHCarouselViewDelegate>

@property (nonatomic, strong) NSString *dotColor;
@property (nonatomic, strong) NSString *dotActiveColor;
@property (nonatomic, strong) NSArray<NSString *> *names;
@property (nonatomic, strong) NSArray<NSString *> *urls;

@property (nonatomic, copy) RCTDirectEventBlock onSelect;


@end

@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

- (void)setDotColor:(NSString *)dotColor {
    _dotColor = dotColor;
    [self setIndicatorColor:[UIColor colorWithHex:dotColor]];
}

- (void)setDotActiveColor:(NSString *)dotActiveColor {
    _dotActiveColor = dotActiveColor;
    [self setCurrentIndicatorColor:[UIColor colorWithHex:dotActiveColor]];
}

- (void)setNames:(NSArray<NSString *> *)names {
    _names = names;
    [self loadImageNames:names];
}


- (void)setUrls:(NSArray<NSString *> *)urls {
    if (!urls || urls.count <= 0) {
        return;
    }
    _urls = urls;
    self.imageCount = urls.count;
}

#pragma mark - YHCarouselViewDelegate
- (void)carouselView:(YHCarouselView *)carouselView didSelectedAtIndex:(NSUInteger)index {
    if (self.onSelect) {
        self.onSelect(@{@"index": @(index)});
    }
}

- (void)carouselView:(YHCarouselView *)carouselView didShowAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView {
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.urls objectAtIndex:index]]
                 placeholderImage:[UIImage imageNamed:@"pic_default"]];
}


@end

@interface CarouselViewManager ()<YHCarouselViewDelegate>

@end

@implementation CarouselViewManager

RCT_EXPORT_MODULE(CarouselView)

RCT_EXPORT_VIEW_PROPERTY(dotColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(dotActiveColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(names, NSArray)
RCT_EXPORT_VIEW_PROPERTY(urls, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onSelect, RCTDirectEventBlock)


- (UIView *)view {
    CarouselView *carouselView = [[CarouselView alloc] init];
    return carouselView;
}


@end
