//
//  SFScrollView.h
//  SFScrollView
//
//  Created by 花菜 on 2017/6/7.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SFImageClick)(NSInteger selecedIndex);
@class SFScrollView;
@protocol SFScrollViewDelegate <NSObject>

@optional

/**
 通知代理选中了图片

 @param scrollview scrollview
 @param index 图片索引
 */
- (void)sf_scrollview:(SFScrollView *)scrollview didSelectedItemAtIndex:(NSInteger)index;

@end
@interface SFScrollView : UIView

/**
 选中索引代理
 */
@property (nonatomic, weak) id<SFScrollViewDelegate> delegate;

/** 占位图*/
@property (nonatomic, strong) UIImage *placeholderImage;

/** 滚动延时*/
@property (nonatomic, assign) NSTimeInterval autoScrollDelay;
@property (nonatomic, assign) SFImageClick imageClick;
/**
 快速创建SFScrollView

 @param frame frame
 @param images 图片数组
 @return SFScrollView 对象
 */
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <NSString *> *)images;

/**
 开始滚动
 */
- (void)beginScroll;

/**
 结束滚动
 */
- (void)stopScroll;
@end
