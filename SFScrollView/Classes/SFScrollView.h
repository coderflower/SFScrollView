//
//  SFScrollView.h
//  SFScrollView
//
//  Created by 花菜 on 2017/6/7.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SFScrollViewConfig.h"
#import "SFScrollViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN
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
 图片数组
 */
@property (nonatomic, copy) NSArray <id<SFScrollViewProtocol>> * dataSource;
/**
 图片点击回调事件代理
 */
@property (nonatomic, weak) id<SFScrollViewDelegate> delegate;

/**
 使用 Block 方式回调
 */
@property (nonatomic, assign) SFImageClick imageClick;

/**
 快速创建SFScrollView

 @param frame frame
 @param images 图片数组
 @return SFScrollView 对象
 */
+ (instancetype)sf_scrollViewWithFrame:(CGRect)frame images:(NSArray <id<SFScrollViewProtocol>> * _Nonnull )images placeholer:(nullable UIImage * )placeholer;
/**
 快速创建SFScrollView
 
 @param frame frame
 @param images 图片数组
 @return SFScrollView 对象
 */
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <id<SFScrollViewProtocol>> * _Nonnull)images placeholer:(nullable UIImage *)placeholer;

/**
 快速创建SFScrollView

 @param frame frame
 @param placeholer 占位图
 @return SFScrollView 对象
 */
- (instancetype)initWithFrame:(CGRect)frame placehoder:(nullable UIImage *)placeholer;
/**
 更新配置

 @param config SFScrollViewConfig对象
 */
- (void)updateWithConfig:(void(^)(SFScrollViewConfig *))config;
/**
 开始滚动
 */
- (void)beginScroll;

/**
 结束滚动
 */
- (void)stopScroll;
@end
NS_ASSUME_NONNULL_END





