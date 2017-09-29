//
//  YHImageView.m
//  KitDemo
//
//  Created by Hu on 16/8/1.
//  Copyright © 2016年 redye. All rights reserved.
//

#import "YHCarouselView.h"

#define kCarouselViewPageControlHeight     20
#define kCarouselViewWidth                 CGRectGetWidth(self.frame)
#define kCarouselViewAnimationDelay        3
#define kCarouselViewAnimationDuration     0.5

@interface YHCarouselView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControll;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation YHCarouselView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setUI];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutUI];
}

- (void)layoutUI {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    self.scrollView.frame = CGRectMake(0, 0, width, height);
    self.scrollView.contentSize = CGSizeMake(width * 3, height);
    self.pageControll.frame = CGRectMake(0, height - kCarouselViewPageControlHeight, CGRectGetWidth(self.frame), kCarouselViewPageControlHeight);
    self.leftImageView.frame = CGRectMake(width * 0, 0, width, height);
    self.centerImageView.frame = CGRectMake(width * 1, 0, width, height);
    self.rightImageView.frame = CGRectMake(width * 2, 0, width, height);
    self.scrollView.contentOffset = CGPointMake(kCarouselViewWidth, 0);
}

- (void)setUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _pageControll = [[UIPageControl alloc] init];
    _pageControll.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControll.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControll.currentPage = _currentIndex;
    _pageControll.enabled = NO;
    [self addSubview:_pageControll];
    
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_leftImageView];
    
    _centerImageView = [[UIImageView alloc] init];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_centerImageView];
    
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_rightImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)animation {    
    [UIView animateWithDuration:kCarouselViewAnimationDuration animations:^{
        CGPoint offset = self.scrollView.contentOffset;
        self.scrollView.contentOffset = CGPointMake(offset.x + kCarouselViewWidth, offset.y);
    } completion:^(BOOL finished) {
        [self updateUI];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(animation) withObject:nil afterDelay:kCarouselViewAnimationDelay];
        });
    }];
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    NSLog(@"点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(carouselView:didSelectedAtIndex:)]) {
        [self.delegate carouselView:self didSelectedAtIndex:self.currentIndex];
    }
}

- (void)setImageCount:(NSUInteger)imageCount {
    _imageCount = imageCount;
    [self setDefaultImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(animation) withObject:nil afterDelay:kCarouselViewAnimationDelay];
    });

}

- (void)setIndicatorColor:(UIColor *)color {
    _pageControll.pageIndicatorTintColor = color;
}

- (void)setCurrentIndicatorColor:(UIColor *)color {
    _pageControll.currentPageIndicatorTintColor = color;
}

- (void)loadImageNames:(NSArray *)imageNames {
    self.imageNames = imageNames;
    self.imageCount = imageNames.count;
}

- (void)setDefaultImage {
    _currentIndex = 0;
    _scrollView.scrollEnabled = _imageCount > 1;
    _pageControll.hidden = _imageCount == 1;
    _pageControll.numberOfPages = _imageCount;
    NSUInteger leftIndex = _imageCount - 1;
    NSUInteger rightIndex = (_currentIndex + 1) % _imageCount;
    if (!_imageNames) {
        [self requestImageWithLeftIndex:leftIndex rightIndex:rightIndex];
        return;
    }
    _leftImageView.image = [UIImage imageNamed:_imageNames[leftIndex]];
    _centerImageView.image = [UIImage imageNamed:_imageNames[_currentIndex]];
    _rightImageView.image = [UIImage imageNamed:_imageNames[rightIndex]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateUI];
}

- (void)updateUI {
    [self reloadImage];
    
    [self.scrollView setContentOffset:CGPointMake(kCarouselViewWidth, 0) animated:NO];
    
    self.pageControll.currentPage = self.currentIndex;
}

- (void)reloadImage {
    NSUInteger leftIndex, rightIndex;
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.x > kCarouselViewWidth) { // 向右滑动
        self.currentIndex = (self.currentIndex + 1) % self.imageCount;
    } else if (offset.x < kCarouselViewWidth){ // 向左滑动
        self.currentIndex = (self.currentIndex + self.imageCount - 1) % self.imageCount;
    }
    leftIndex = (self.currentIndex + self.imageCount - 1) % self.imageCount;
    rightIndex = (self.currentIndex + 1) % self.imageCount;
    if (!self.imageNames) {
        [self requestImageWithLeftIndex:leftIndex rightIndex:rightIndex];
        return;
    }
    self.centerImageView.image = [UIImage imageNamed:self.imageNames[self.currentIndex]];
    self.leftImageView.image = [UIImage imageNamed:self.imageNames[leftIndex]];
    self.rightImageView.image = [UIImage imageNamed:self.imageNames[rightIndex]];
}

- (void)requestImageWithLeftIndex:(NSUInteger)leftIndex rightIndex:(NSUInteger)rightIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(carouselView:didShowAtIndex:imageView:)]) {
        [self.delegate carouselView:self didShowAtIndex:self.currentIndex imageView:self.centerImageView];
        [self.delegate carouselView:self didShowAtIndex:leftIndex imageView:self.leftImageView];
        [self.delegate carouselView:self didShowAtIndex:rightIndex imageView:self.rightImageView];
    }
}

@end
