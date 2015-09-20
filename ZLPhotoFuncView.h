//
//  ZLPhotoFuncView.h
//  CircleImage
//
//  Created by ZhangLiang on 15/9/11.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZLPhotoFuncViewTypeDetail = 0,  // 查看详情
    ZLPhotoFuncViewTypeDelete,      // 删除
    ZLPhotoFuncViewTypeOther        // 其他
} ZLPhotoFuncViewType;

/**
 *  点击查看详情Block
 *
 *  @param photoFuncViewType ZLPhotoFuncViewType
 */
typedef void (^ZLPhotoFuncViewBlock)(ZLPhotoFuncViewType photoFuncViewType);

/**
 *  @brief 图标功能按钮
 */
@interface ZLPhotoFuncView : UIView

@property (nonatomic, copy) ZLPhotoFuncViewBlock photoFuncViewBlock;

@end
