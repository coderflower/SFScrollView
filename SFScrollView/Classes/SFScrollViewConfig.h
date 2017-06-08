//
//  SFScrollViewConfig.h
//  Pods
//
//  Created by 花菜 on 2017/6/8.
//
//

#import <Foundation/Foundation.h>

@interface SFScrollViewConfig : NSObject

/**
 页面指示器的颜色
 */
@property (nonatomic, strong) UIColor * pageIndicatorTintColor;
/**
 当前页面指示器的颜色
 */
@property (nonatomic, strong) UIColor * currentPageIndicatorTintColor;
/** 
滚动延时 默认两秒
 */
@property (nonatomic, assign) NSTimeInterval autoScrollDelay;

+ (instancetype)defaultConfig;
@end
