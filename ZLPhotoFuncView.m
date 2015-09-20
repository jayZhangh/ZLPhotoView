//
//  ZLPhotoFuncView.m
//  CircleImage
//
//  Created by ZhangLiang on 15/9/11.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import "ZLPhotoFuncView.h"

@interface ZLPhotoFuncView ()

@property (nonatomic, strong) UIButton *btn_detail;
@property (nonatomic, strong) UIButton *btn_delete;
@property (nonatomic, strong) UIButton *btn_other;

@end

@implementation ZLPhotoFuncView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    if (!self.btn_detail) {
        self.btn_detail = [[UIButton alloc] init];
//        [self.btn_detail setImage:[UIImage imageNamed:@"icon_delete_red"] forState:UIControlStateNormal];
        [self.btn_detail setBackgroundColor:[UIColor redColor]];
        self.btn_detail.tag = ZLPhotoFuncViewTypeDetail;
        [self addSubview:self.btn_detail];
        
        [self.btn_detail addTarget:self action:@selector(btnAction_func:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.btn_delete) {
        self.btn_delete = [[UIButton alloc] init];
//        [self.btn_delete setImage:[UIImage imageNamed:@"icon_increase_red"] forState:UIControlStateNormal];
        [self.btn_delete setBackgroundColor:[UIColor greenColor]];
        self.btn_delete.tag = ZLPhotoFuncViewTypeDelete;
        [self addSubview:self.btn_delete];
        
        [self.btn_delete addTarget:self action:@selector(btnAction_func:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.btn_other) {
        self.btn_other = [[UIButton alloc] init];
//        [self.btn_other setImage:[UIImage imageNamed:@"icon_delete_red"] forState:UIControlStateNormal];
        [self.btn_other setBackgroundColor:[UIColor lightGrayColor]];
        self.btn_other.tag = ZLPhotoFuncViewTypeOther;
        [self addSubview:self.btn_other];
        
        [self.btn_other addTarget:self action:@selector(btnAction_func:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat f_cols = 3;
    CGFloat f_width = self.frame.size.width;
    CGFloat f_margin = 5;
    
    CGFloat f_buttonWH = (f_width - (f_cols - 1) * f_margin) / f_cols;
    self.btn_detail.frame = CGRectMake(0, 0, f_buttonWH, f_buttonWH);
    self.btn_delete.frame = CGRectMake(CGRectGetMaxX(self.btn_detail.frame) + f_margin, 0, f_buttonWH, f_buttonWH);
    self.btn_other.frame = CGRectMake(CGRectGetMaxX(self.btn_delete.frame) + f_margin, 0, f_buttonWH, f_buttonWH);
}

/**
 *  点击详情按钮
 */
- (void)btnAction_func:(UIButton *)sender {
    if (self.photoFuncViewBlock) {
        self.photoFuncViewBlock(sender.tag);
    }
}

@end
