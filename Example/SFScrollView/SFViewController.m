//
//  SFViewController.m
//  SFScrollView
//
//  Created by chriscaixx on 06/07/2017.
//  Copyright (c) 2017 chriscaixx. All rights reserved.
//

#import "SFViewController.h"
#import <SFScrollView/SFScrollView.h>
#import "SFImageItem.h"
@interface SFViewController ()<SFScrollViewDelegate>
@property (nonatomic, strong) NSArray * netImageArray;
@property (nonatomic, strong) SFScrollView * netScrollView;
/** 本地图片数组*/
@property(nonatomic,strong)NSArray *localImageArray;
@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /** 创建网络滚动视图*/
    [self createNetScrollView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_netScrollView beginScroll];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_netScrollView stopScroll];
}

-(NSArray *)netImageArray
{
    if(!_netImageArray)
    {
        NSArray * tmp = @[@"http://ws.xzhushou.cn/focusimg/201508201549023.jpg",@"http://ws.xzhushou.cn/focusimg/52.jpg",@"http://ws.xzhushou.cn/focusimg/51.jpg",@"http://ws.xzhushou.cn/focusimg/50.jpg"];

        NSMutableArray * tmpM = [NSMutableArray array];
        for (NSString * name in tmp) {
            SFImageItem * item = [[SFImageItem alloc] init];
            
            item.imageName = name;
            [tmpM addObject:item];
        }
        _netImageArray = [tmpM copy];
    }
    return _netImageArray;
}
-(NSArray *)localImageArray
{
    if(!_localImageArray)
    {
        NSArray * tmp = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        
        NSMutableArray * tmpM = [NSMutableArray array];
        for (NSString * name in tmp) {
            SFImageItem * item = [[SFImageItem alloc] init];
            
            item.imageName = name;
            [tmpM addObject:item];
        }
        _localImageArray = [tmpM copy];
    }
    return _localImageArray;
}
-(void)createNetScrollView
{
    UILabel * topLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
    
    topLable.text = @"加载网络图片演示";
    topLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLable];

    UIImage * image =[UIImage imageNamed:@"placeholderImage"];
    /** 设置网络scrollView的Frame及所需图片*/
    SFScrollView * netScrollView = [[SFScrollView alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 200) placehoder:image];
    /** 设置占位图*/
    netScrollView.dataSource = self.netImageArray;
    /** 获取网络图片的index*/
    netScrollView.delegate = self;
    
    /** 添加到当前View上*/
    [self.view addSubview:netScrollView];
    _netScrollView = netScrollView;
    
    [netScrollView updateWithConfig:^(SFScrollViewConfig * config) {
        config.pageIndicatorTintColor = [UIColor redColor];
        config.currentPageIndicatorTintColor = [UIColor yellowColor];
        config.autoScrollDelay = 5;
    }];
   
    UILabel * bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 364, self.view.frame.size.width, 20)];;

    bottomLabel.text = @"加载本地图片演示";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    
    SFScrollView * localScrollView = [SFScrollView sf_scrollViewWithFrame:CGRectMake(0, 384, self.view.frame.size.width, 200) images:self.localImageArray placeholer:image];
    
    
    [self.view addSubview:localScrollView];
    _netScrollView = localScrollView;
    
    [localScrollView updateWithConfig:^(SFScrollViewConfig * config) {
        config.pageIndicatorTintColor = [UIColor purpleColor];
        config.currentPageIndicatorTintColor = [UIColor blueColor];
    }];
    
    localScrollView.imageClick = ^(NSInteger selecedIndex){
        NSLog(@"使用 block 回调---> 点击了第%zd张本地图片",selecedIndex);
    };
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController * vc = [[UIViewController alloc] init];
    
    vc.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)sf_scrollview:(SFScrollView *)scrollview didSelectedItemAtIndex:(NSInteger)index
{
    NSLog(@"使用代理回调---> 点击了第%zd张网络图片",index);
    
    
    
    NSLog(@"%@",self.netImageArray[index]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
