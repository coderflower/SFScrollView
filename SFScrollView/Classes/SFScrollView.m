//
//  SFScrollView.m
//  SFScrollView
//
//  Created by 花菜 on 2017/6/7.
//  Copyright © 2017年 chriscaixx. All rights reserved.
//

#import "SFScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
/** 滚动宽度*/
#define ScrollWidth self.frame.size.width

/** 滚动高度*/
#define ScrollHeight self.frame.size.height


static CGFloat const defaultPageSize = 16;
@interface SFScrollView () <UIScrollViewDelegate>

/** 配置信息 */
@property(nonatomic, strong)  SFScrollViewConfig *config;
/** 滚动延时*/
@property (nonatomic, assign) NSTimeInterval autoScrollDelay;
/** 占位图 */
@property(nonatomic, strong)UIImage * placeholderImage;
@end
@implementation SFScrollView
{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_pageControl;
    
    __weak NSTimer *_timer;
    
    
    /** 当前显示的是第几个*/
    NSInteger _currentIndex;
    
    /** 图片个数*/
    NSInteger _maxImageCount;
    
    /** 是否是网络图片*/
    BOOL _isNetworkImage;

}

+ (instancetype)sf_scrollViewWithFrame:(CGRect)frame images:(NSArray <id<SFScrollViewProtocol>> * _Nonnull )images placeholer:(nullable UIImage * )placeholder;
{
    SFScrollView * sf_scrollView = [[SFScrollView alloc] initWithFrame:frame images:images placeholder:placeholder];
    
    return sf_scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <id<SFScrollViewProtocol>> * _Nonnull )images placeholder:(nullable UIImage *)placeholder;
{
    
    
    SFScrollView * sf_scrollView = [[SFScrollView alloc] initWithFrame:frame placeholder:placeholder];
    // 设置图片
    [sf_scrollView setDataSource:images];
    
    return sf_scrollView;
}
- (instancetype)initWithFrame:(CGRect)frame placehoder:(nullable UIImage *)placeholder
{
    SFScrollView * sf_scrollView = [[SFScrollView alloc] initWithFrame:frame];
    
    sf_scrollView.placeholderImage = placeholder;
    
    return sf_scrollView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _isNetworkImage = NO;
        // 初始化内容试图
        [self initScrollView];
    }
    return self;
}

- (void)updateWithConfig:(void(^)(SFScrollViewConfig *))config
{
    if (config)
    {
        config(self.config);
    }
    _pageControl.pageIndicatorTintColor = self.config.pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = self.config.currentPageIndicatorTintColor;
    self.autoScrollDelay = self.config.autoScrollDelay;
}
- (void)initScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    /** 复用，创建三个*/
    scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
    
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 0;
    
    _scrollView = scrollView;
}


/**
 设置数据源

 @param dataSource 数据源
 */
- (void)setDataSource:(NSArray<id<SFScrollViewProtocol>> *)dataSource
{
    // 判断是否是网络图片
    id<SFScrollViewProtocol> firstItme = dataSource.firstObject;
    if ([firstItme.imageName hasPrefix:@"http"])
    {
        _isNetworkImage = YES;
    }
    _dataSource = [dataSource copy];
    
    [self setMaxImageCount:_dataSource.count];

}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    /** 添加定时器*/
    [self addTimer];
}

/**
 设置最大图片数

 @param maxImageCount 最大图片数
 */
-(void)setMaxImageCount:(NSInteger)maxImageCount
{
    _maxImageCount = maxImageCount;
    
    /** 复用imageView初始化*/
    [self initImageView];
    
    /** pageControl*/
    [self initPageControl];
    /** 初始化图片位置*/
    [self changeImageLeft:_maxImageCount-1 center:0 right:1];
}

/**
 设置滚动间隔

 @param autoScrollDelay 滚动间隔时间默认为2
 */
- (void)setAutoScrollDelay:(NSTimeInterval)autoScrollDelay
{
    _autoScrollDelay = autoScrollDelay;
    
    [self removeTimer];
    [self addTimer];
}

/**
 初始化PageControl
 */
-(void)initPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,ScrollHeight - defaultPageSize,ScrollWidth, 8)];
    
    //设置页面指示器的颜色
    pageControl.pageIndicatorTintColor = self.config.pageIndicatorTintColor;
    //设置当前页面指示器的颜色
    pageControl.currentPageIndicatorTintColor = self.config.currentPageIndicatorTintColor;
    pageControl.numberOfPages = _maxImageCount;
    pageControl.currentPage = 0;
    
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
}


/**
 初始化3个 imageView
 */
- (void)initImageView {
    
    CGRect frame = CGRectMake(0, 0,ScrollWidth, ScrollHeight);
    // 添加3个 imageView
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:frame];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView * centerImageView = [[UIImageView alloc] initWithFrame:CGRectOffset(frame, ScrollWidth, 0)];
    centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectOffset(frame, ScrollWidth * 2, 0)];
    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    centerImageView.userInteractionEnabled = YES;
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
}
#pragma mark -
#pragma mark - ===== 调用代理方法 =====
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    // 使用代理回调
    if (_delegate && [_delegate respondsToSelector:@selector(sf_scrollview:didSelectedItemAtIndex:)])
    {
        [_delegate sf_scrollview:self didSelectedItemAtIndex:_currentIndex];
    }
    // 使用 block 回调
    if (self.imageClick)
    {
        self.imageClick(_currentIndex);
    }
}

#pragma mark -
#pragma mark - ===== UIScrollViewDelegate =====

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //开始滚动，判断位置，然后替换复用的三张图
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

#pragma mark -
#pragma mark - ===== 逻辑事件 =====


/**
 根据索引设置图片
 
 @param leftIndex LeftIndex
 @param centerIndex centerIndex
 @param rightIndex rightIndex
 */
- (void)changeImageLeft:(NSInteger)leftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (_isNetworkImage)
    {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[leftIndex].imageName] placeholderImage:_placeholderImage];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[centerIndex].imageName] placeholderImage:_placeholderImage];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[rightIndex].imageName] placeholderImage:_placeholderImage];
    }
    else
    {
        _leftImageView.image = [UIImage imageNamed:_dataSource[leftIndex].imageName];
        _centerImageView.image = [UIImage imageNamed:_dataSource[centerIndex].imageName];
        _rightImageView.image = [UIImage imageNamed:_dataSource[rightIndex].imageName];
    }
    
    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}

/**
 根据偏移量修改索引

 @param offsetX scrollView便宜量
 */
- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX >= ScrollWidth * 2)
    {
        _currentIndex++;
        
        if (_currentIndex == _maxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }
        else if (_currentIndex == _maxImageCount)
        {
            
            _currentIndex = 0;
            
            [self changeImageLeft:_maxImageCount-1 center:0 right:1];
            
        }
        else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _pageControl.currentPage = _currentIndex;
        
    }
    
    if (offsetX <= 0)
    {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_maxImageCount-1 center:0 right:1];
            
        }
        else if (_currentIndex == -1)
        {
            
            _currentIndex = _maxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }
        else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _pageControl.currentPage = _currentIndex;
    }
}
#pragma mark -
#pragma mark - ===== 定时器相关 =====

/**
 添加定时器
 */
- (void)addTimer
{
    [self removeTimer];
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:_autoScrollDelay target:self selector:@selector(autoScorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer = timer;
}

- (void)autoScorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}


/**
 移除定时器
 */
- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -
#pragma mark - ===== getter =====
- (SFScrollViewConfig *)config
{
    if (!_config)
    {
        _config =  [SFScrollViewConfig defaultConfig];
    }
    return _config;
}
/**
 开启滚动
 */
- (void)beginScroll
{
    [self addTimer];
}

/**
 结束滚动
 */
- (void)stopScroll
{
    [self removeTimer];
}

- (void)dealloc
{
    [self removeTimer];
}

@end
