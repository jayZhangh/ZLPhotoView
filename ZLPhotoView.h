//
//  ZLPhotoView.h
//  CircleImage
//
//  Created by ZhangLiang on 15/9/10.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoFuncView.h"

@interface ZLPhotoView : UIView

// 图片
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) UIImage *placeholderImg;

@property (nonatomic, strong) ZLPhotoFuncView *photoFuncView;  /**< 功能按钮 */

@end
