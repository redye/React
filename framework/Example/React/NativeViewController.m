//
//  NativeViewController.m
//  React
//
//  Created by redye.hu on 2017/9/29.
//  Copyright © 2017年 redye.hu. All rights reserved.
//

#import "NativeViewController.h"
#import "YHCarouselView.h"
#import "UIImageView+WebCache.h"


@interface NativeViewController ()<YHCarouselViewDelegate>

@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setUI];
}

- (void)initData {
    
    _imageNames = @[@"IMG_0010.JPG",
                    @"IMG_0021.JPG",
                    @"IMG_0023.JPG",
                    @"IMG_0149.JPG",
                    @"IMG_0151.JPG",
                    @"IMG_0166.JPG"
                    ];
    
    _imageUrls = @[@"http://a.hiphotos.baidu.com/zhidao/pic/item/72f082025aafa40fa38bfc55a964034f79f019ec.jpg",
                   @"http://photo.enterdesk.com/2011-2-16/enterdesk.com-1AA0C93EFFA51E6D7EFE1AE7B671951F.jpg",
                   @"http://dl.bizhi.sogou.com/images/2012/09/30/44928.jpg",
                   @"http://dl.bizhi.sogou.com/images/2012/03/08/96703.jpg",
                   @"http://image.tianjimedia.com/uploadImages/2012/010/XC4Y39BYZT9A.jpg",
                   @"http://pic51.nipic.com/file/20141030/2531170_080422201000_2.jpg"
                   ];
}

- (void)setUI {

    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), 30)];
    [label setText:@"本地图片"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    YHCarouselView *carouselView = [[YHCarouselView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), self.view.bounds.size.width, 200)];
    [carouselView loadImageNames:self.imageNames];
    carouselView.delegate = self;
    [self.view addSubview:carouselView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carouselView.frame) + 30, CGRectGetWidth(self.view.frame), 30)];
    [label2 setText:@"网络图片"];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    YHCarouselView *carouselView2 = [[YHCarouselView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame), CGRectGetWidth(self.view.frame), 200)];
    carouselView2.delegate = self;
    carouselView2.imageCount = self.imageUrls.count;
    [self.view addSubview:carouselView2];
}

#pragma mark - YHCarouselViewDelegate
- (void)carouselView:(YHCarouselView *)carouselView didShowAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView {
    NSString *url = [_imageUrls objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_default"]];
}

- (void)carouselView:(YHCarouselView *)carouselView didSelectedAtIndex:(NSUInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"index" message:[NSString stringWithFormat:@"index-%lu", (unsigned long)index] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
