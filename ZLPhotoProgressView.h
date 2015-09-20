//
//  ZLPhotoProgressView.h
//  CircleImage
//
//  Created by ZhangLiang on 15/9/11.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 加载进度
 */
@interface ZLPhotoProgressView : UIView

- (void)start;
- (void)stop;
- (BOOL)isRun;

@end
