//
//  ZLPhotoView.m
//  CircleImage
//
//  Created by ZhangLiang on 15/9/10.
//  Copyright (c) 2015年 ZhangLiang. All rights reserved.
//

#import "ZLPhotoView.h"
#import "ZLPhotoProgressView.h"
#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"

@interface ZLPhotoViewModel : NSObject

@property (nonatomic, assign) NSInteger photoId;      /**< 下载ID */
@property (nonatomic, strong) NSURL *downloadUrl;  /**< 下载的Url */
@property (nonatomic, strong) UIImage *finishImage;   /**< 下载完毕的图片 */

@end

@implementation ZLPhotoViewModel

@end

@interface ZLPhotoView ()
{
    UIImageView *_imageView;
    CGPoint _startPoint;
    CGPoint _endPoint;
    NSInteger _currentIndex;
    BOOL _isShowFunc;
}

@property (nonatomic, strong) ZLPhotoProgressView *view_photoProgress;  /**< 加载进度 */
@property (nonatomic, strong) NSMutableArray *array_image;      /**< 图片数组 */

@end

@implementation ZLPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    self.clipsToBounds = YES;
    
    // 图片
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    
    // 图片功能按钮视图
    if (!self.photoFuncView) {
        self.photoFuncView = [[ZLPhotoFuncView alloc] init];
        self.photoFuncView.hidden = YES;
        [self addSubview:self.photoFuncView];
    }
    
    // 监听点击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    // 监听滑动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [self addGestureRecognizer:panRecognizer];
    
    // 加载进度视图
    if (!self.view_photoProgress) {
        self.view_photoProgress = [[ZLPhotoProgressView alloc] init];
        [self addSubview:self.view_photoProgress];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat f_width = self.frame.size.width;
    _imageView.frame = self.bounds;
    
    CGFloat f_photoFuncW = 60;
    CGFloat f_photoFuncH = 20;
    CGFloat f_photoFuncX = f_width - f_photoFuncW - 5;
    CGFloat f_photoFuncY = -(f_photoFuncH);
    self.photoFuncView.frame = CGRectMake(f_photoFuncX, f_photoFuncY, f_photoFuncW, f_photoFuncH);
    
    self.view_photoProgress.frame = _imageView.bounds;
}

/**
 *  单击图片
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if ([self.view_photoProgress isRun]) {
        return;
    }
    
    CGFloat f_duration = 0.3;
    // 添加功能按钮
    if (!_isShowFunc) { // 显示
        _isShowFunc = YES;
        
        self.photoFuncView.alpha = 0.0;
        [UIView animateWithDuration:f_duration animations:^{
            CGRect frame = self.photoFuncView.frame;
            frame.origin.y = 3;
            self.photoFuncView.frame = frame;
            self.photoFuncView.alpha = 1.0;
            self.photoFuncView.hidden = NO;
        }];
        
    } else {    // 隐藏
        _isShowFunc = NO;
        [UIView animateWithDuration:f_duration animations:^{
            CGRect frame = self.photoFuncView.frame;
            frame.origin.y = -(frame.size.height + 3);
            self.photoFuncView.frame = frame;
            self.photoFuncView.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.photoFuncView.hidden = YES;
        }];
    }
}

/**
 *  滑动图片
 */
- (void)panRecognizer:(UIPanGestureRecognizer *)recognizer {
    if ([self.view_photoProgress isRun]) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:recognizer.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startPoint = point;
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        _endPoint = point;
        return;
    }
    
    if (CGPointEqualToPoint(point, _startPoint)) {
        return;
    }
    
    NSInteger index = 0;
    UIImage *currentImage = nil;
    ZLPhotoViewModel *photoViewModel = nil;
    if (point.x > _startPoint.x) {
        if (_currentIndex <= 0) {
            _currentIndex = 1;
        }
        
        index = --_currentIndex;
        photoViewModel = [self photoViewModelWithId:index];
        currentImage = photoViewModel.finishImage;
        
        if (!currentImage) {    // 默认为最后一张，防止滑动过快切换为空图片
            photoViewModel = [self.array_image firstObject];
            currentImage = photoViewModel.finishImage;
        }
        
    } else {
        if (_currentIndex >= [self.array_image count] - 1) {
            _currentIndex = [self.array_image count] - 2;
        }
        
        index = ++_currentIndex;
        photoViewModel = [self photoViewModelWithId:index];
        currentImage = photoViewModel.finishImage;
        
        if (!currentImage) {    // 默认为最后一张，防止滑动过快切换为空图片
            photoViewModel = [self.array_image lastObject];
            currentImage = photoViewModel.finishImage;
        }
    }
    
    _imageView.image = currentImage;
}

- (ZLPhotoViewModel *)photoViewModelWithId:(NSInteger)photoId {
    ZLPhotoViewModel *currentPhoto = nil;
    for (ZLPhotoViewModel *model in self.array_image) {
        if (model.photoId == photoId) {
            currentPhoto = model;
            break;
        }
    }
    
    return currentPhoto;
}

/**
 *  添加图片Photo
 */
- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    GSLog(@"%@", path);
    
    if ([photos count] > 0) {
        [self.view_photoProgress start];
        _currentIndex = 0;
        [self downloadImages];
    }
}

#pragma mark - 下载图片
- (void)downloadImages {
    self.array_image = [NSMutableArray arrayWithCapacity:0];
    UIImage *img_placeholder = self.placeholderImg;
    if (!self.placeholderImg) {
        img_placeholder = [UIImage imageNamed:@"login_number"];    // 占位图片
    }
    
    _imageView.image = img_placeholder;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // 循环下载
    for (int i = 0; i < [self.photos count]; i++) {
        ZLPhoto *photo = self.photos[i];
        
        // 判断是否为URL链接，否则直接添加
        if (!photo.url) {
            [self photoDidFinishLoadWithImage:photo.image photoId:i downloadURL:photo.url];
            continue;
        }
        
        // 不是gif，就马上开始下载图片
        if (![photo.url.absoluteString hasSuffix:@"gif"]) {
            __unsafe_unretained ZLPhotoView *photoView = self;
            
            // 缓存下载操作
            [manager downloadImageWithURL:photo.url options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [photoView photoDidFinishLoadWithImage:image photoId:i downloadURL:imageURL];
                if (i == 0) {
                    _imageView.image = image;
                }
            }];
        }
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image photoId:(NSInteger)photoId downloadURL:(NSURL *)downloadURL {
    if (image) {
        ZLPhotoViewModel *photoViewModel = [[ZLPhotoViewModel alloc] init];
        photoViewModel.finishImage = image;
        photoViewModel.photoId = photoId;
        photoViewModel.downloadUrl = downloadURL;
        [self.array_image addObject:photoViewModel];
    }
    
//    NSLog(@"%d, %d", [self.array_image count], [self.photos count]);
    if ([self.array_image count] >= [self.photos count]) {
        [self.view_photoProgress stop];
        [self.view_photoProgress removeFromSuperview];
        self.view_photoProgress = nil;
    }
}

- (void)dealloc
{
    // 取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

@end
