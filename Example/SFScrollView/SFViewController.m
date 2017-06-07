//
//  SFViewController.m
//  SFScrollView
//
//  Created by chriscaixx on 06/07/2017.
//  Copyright (c) 2017 chriscaixx. All rights reserved.
//

#import "SFViewController.h"
#import "SFScrollView.h"
@interface SFViewController ()<SFScrollViewDelegate>
@property (nonatomic, strong) NSArray * NetImageArray;
@property (nonatomic, strong) SFScrollView * WYNetScrollView;
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
    [_WYNetScrollView beginScroll];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_WYNetScrollView stopScroll];
}

-(NSArray *)NetImageArray
{
    if(!_NetImageArray)
    {
        _NetImageArray = @[@"http://ws.xzhushou.cn/focusimg/201508201549023.jpg",@"http://ws.xzhushou.cn/focusimg/52.jpg",@"http://ws.xzhushou.cn/focusimg/51.jpg",@"http://ws.xzhushou.cn/focusimg/50.jpg"];
    }
    return _NetImageArray;
}

-(void)createNetScrollView
{
    /** 设置网络scrollView的Frame及所需图片*/
    SFScrollView *WYNetScrollView = [[SFScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200) images:self.NetImageArray];
    
    /** 设置滚动延时*/
    WYNetScrollView.autoScrollDelay = 3;
    
    /** 设置占位图*/
    WYNetScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    
    
    /** 获取网络图片的index*/
    WYNetScrollView.delegate = self;
    
    /** 添加到当前View上*/
    [self.view addSubview:WYNetScrollView];
    _WYNetScrollView = WYNetScrollView;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController * vc = [[UIViewController alloc] init];
    
    vc.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)sf_scrollview:(SFScrollView *)scrollview didSelectedItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd张图片",index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
