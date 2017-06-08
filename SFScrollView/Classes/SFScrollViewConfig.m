//
//  SFScrollViewConfig.m
//  Pods
//
//  Created by 花菜 on 2017/6/8.
//
//

#import "SFScrollViewConfig.h"

@implementation SFScrollViewConfig
+ (instancetype)defaultConfig
{
    SFScrollViewConfig * config = [[SFScrollViewConfig alloc] init];
    
    config.pageIndicatorTintColor = [UIColor lightGrayColor];
    config.currentPageIndicatorTintColor = [UIColor redColor];
    config.autoScrollDelay = 2.0;
    return config;
}
@end
