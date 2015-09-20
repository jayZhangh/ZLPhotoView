//
//  ZLPhotoProgressView.m
//  CircleImage
//
//  Created by ZhangLiang on 15/9/11.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import "ZLPhotoProgressView.h"

@interface ZLPhotoProgressView ()

@property (nonatomic, strong) UIView *view_cover;       /**< 背景遮罩 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;   /**< 加载进度 */

@end

@implementation ZLPhotoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    // 背景遮罩
    if (!self.view_cover) {
        [self addSubview:self.view_cover = [UIView.alloc init]];
        self.view_cover.backgroundColor = [UIColor lightGrayColor];
        self.view_cover.alpha = 0.9;
    }
    
    // 加载进度
    if (!self.activityIndicator) {
        [self.view_cover addSubview:self.activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view_cover.frame = self.bounds;
    self.activityIndicator.center = self.view_cover.center;
}

- (void)start {
    [self.activityIndicator startAnimating];
}

- (BOOL)isRun {
    return [self.activityIndicator isAnimating];
}

- (void)stop {
    [self.activityIndicator stopAnimating];
    
    [self.view_cover removeFromSuperview];
    [self.activityIndicator removeFromSuperview];
}

- (void)dealloc {
    self.view_cover = nil;
    self.activityIndicator = nil;
    
    NSLog(@"activityIndicator - dealloc");
}

@end
