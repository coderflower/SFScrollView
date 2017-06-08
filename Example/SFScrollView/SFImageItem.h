//
//  SFImageItem.h
//  SFScrollView
//
//  Created by 花菜 on 2017/6/8.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SFScrollView/SFScrollViewProtocol.h>
@interface SFImageItem : NSObject<SFScrollViewProtocol>
@property (nonatomic, strong) NSString * imageName;
@end
