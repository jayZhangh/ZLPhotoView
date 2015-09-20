//
//  ZLPhoto.h
//  CircleImage
//
//  Created by ZhangLiang on 15/9/10.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPhoto : NSObject

@property (nonatomic, strong) NSURL *url;       /**< 图片路径 */
@property (nonatomic, strong) UIImage *image;   /**< 完整的图片 */

@end
