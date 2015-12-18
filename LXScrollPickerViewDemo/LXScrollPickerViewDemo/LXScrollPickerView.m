//
//  LXScrollPickerView.m
//  LXScrollPickerViewDemo
//
//  Created by Leexin on 15/12/17.
//  Copyright © 2015年 Garden.Lee. All rights reserved.
//

#import "LXScrollPickerView.h"
#import "NSObject+Category.h"
#import "UIView+Extensions.h"
#import "NSArray+Category.h"

#define kColor [UIColor greenColor]
static const CGFloat kIndexViewHeight = 2.f;
static const CGFloat kAnimationDuration = 0.5f;

@interface LXScrollPickerView ()

@property (nonatomic, copy) NSArray *buttonTitleArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indexView; // 下标显示View
@property (nonatomic, strong) UIView *buttonBackgroudView; // 按钮背景View

@property (nonatomic, assign) NSInteger pageCount; // 单屏显示的按钮数
@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, assign) NSInteger buttonCount;
@property (nonatomic, assign) NSInteger selectedIndex; // 当前选中位置

@property (nonatomic, strong) CALayer *highLightLayer;

@end

@implementation LXScrollPickerView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)buttonTitleArray pageCount:(NSInteger)pageCount {
    
    self = [super initWithFrame:frame];
    if (self) {
        if (![buttonTitleArray isNotEmptyArray]) {
            return self;
        }
        self.buttonTitleArray = buttonTitleArray;
        self.pageCount = pageCount;
        self.buttonArray = [NSMutableArray array];
        self.selectedIndex = 0;
        [self addSubView];
    }
    return self;
}

- (void)addSubView {
    
    self.buttonCount = self.buttonTitleArray.count;
    if (!self.pageCount) {
        self.pageCount = 4; // 未设置默认为每页4个button
    }
    self.buttonWidth = SCREEN_WIDTH / self.pageCount;
    
    self.scrollView.frame = self.frame;
    [self addSubview:self.scrollView];
    
    self.indexView.frame = CGRectMake(0, self.height - kIndexViewHeight, self.buttonWidth, kIndexViewHeight);
    [self.scrollView addSubview:self.indexView];
    
    [self addItemButton];
}

- (void)addItemButton { // 生成Item按钮
    
    self.buttonBackgroudView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.height - kIndexViewHeight);
    [self.scrollView addSubview:self.buttonBackgroudView];
    for (int i = 0; i < self.buttonTitleArray.count; i++) {
        UIButton *itemButton = [[UIButton alloc] init]; //[UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemButton setTitleColor:kColor forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(onItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        if (0 == i) {
            itemButton.selected = YES;
        }
        itemButton.frame = CGRectMake(i * self.buttonWidth, 0, self.buttonWidth, self.scrollView.height - kIndexViewHeight);
        [self.buttonArray addObject:itemButton];
        [self.buttonBackgroudView addSubview:itemButton];
    }
    [self addBlackLayer];
}

- (void)addBlackLayer { // 添加CALayer
    
    CALayer *blackLayer = [CALayer layer];
    [blackLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [blackLayer setFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.height)];
    [self.scrollView.layer addSublayer:blackLayer];
    
    self.highLightLayer = [CALayer layer];
    [self.highLightLayer setBackgroundColor:kColor.CGColor];
    [self.highLightLayer setFrame:CGRectMake(0, 0, self.buttonWidth, self.scrollView.height)];
    [blackLayer addSublayer:self.highLightLayer];
    
    [blackLayer setMask:self.buttonBackgroudView.layer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)];
    [self.scrollView addGestureRecognizer:tap];
}

#pragma mark - Public Method

- (void)changeItemButtonFromCurrentToIndex:(NSInteger)index { // 跳转到当前按钮相隔的第N按钮 index: 1 后一位  -1 前一位
    
    NSInteger nextIndex = self.selectedIndex + index;
    if (nextIndex < 0 || nextIndex >= self.buttonArray.count) { // 当偏移到最后一个再跳转到第1个
        if (self.isNeedCycle) {
            nextIndex = 0;
        } else {
            return;
        }
    }
    UIButton *nextBtn = [self.buttonArray safeObjectAtIndex:nextIndex];
    if (nextBtn) {
        if (0 == nextIndex) {
            self.scrollView.contentOffset = CGPointZero;
        }
        [self onItemButtonClick:nextBtn];
    }
}

#pragma mark - Private Method

- (void)adjustItemScrollViewContentOffsetWithClickButton:(UIButton *)clickButton { // 调整ItemscorllView的偏移量
    
    NSInteger scrollOffIndex = self.scrollView.contentOffset.x / self.buttonWidth;
    // 通过比较 点击按钮的index 和 当前scroll偏移的index
    if (self.selectedIndex == scrollOffIndex || (scrollOffIndex - self.selectedIndex) >= (self.pageCount - 1)) {
        CGFloat newOffsetX = self.scrollView.contentOffset.x - SCREEN_WIDTH / 2; // 向左偏移一半屏幕
        if (newOffsetX < 0) {
            newOffsetX = 0;
        }
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.scrollView setContentOffset:CGPointMake(newOffsetX, 0)];
        }];
    } else if ((self.selectedIndex - scrollOffIndex) >= (self.pageCount - 1)) {
        CGFloat newOffsetX = self.scrollView.contentOffset.x + SCREEN_WIDTH / 2; // 向左偏移一半屏幕
        if (newOffsetX >= (self.scrollView.contentSize.width - SCREEN_WIDTH)) {
            newOffsetX = self.scrollView.contentSize.width - SCREEN_WIDTH;
        }
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.scrollView setContentOffset:CGPointMake(newOffsetX, 0)];
        }];
    }
}

- (void)moveHighLightLayerWithClickIndex:(NSInteger)index { // 调整highLightLayer 的位置
    
    // 显示动画
    [CATransaction begin];
    // 是否开启动画
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setValue:[NSNumber numberWithFloat:kAnimationDuration] forKey:kCATransactionAnimationDuration];
    self.highLightLayer.frame = CGRectMake(index * self.buttonWidth, 0, self.buttonWidth, self.scrollView.height);
    [CATransaction commit];
}

#pragma mark - Event Response

- (void)onTapClick:(UITapGestureRecognizer *)sender {
    
    CGPoint clickPoint = [sender locationInView:self.scrollView];
    NSLog(@"%f",clickPoint.x);
    NSInteger index = clickPoint.x / self.buttonWidth;
    UIButton *clickButton = [self.buttonArray safeObjectAtIndex:index];
    [self moveHighLightLayerWithClickIndex:index];
    [self onItemButtonClick:clickButton];
}

- (void)onItemButtonClick:(UIButton *)sender {
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        btn.selected = NO;
        if (btn == sender) {
            btn.selected = YES;
            self.selectedIndex = i;
        }
    }
    [self adjustItemScrollViewContentOffsetWithClickButton:sender];
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        weakSelf.indexView.left = weakSelf.selectedIndex * weakSelf.buttonWidth;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollPickerView:didSelectButtonAtIndex:)]) {
        [self.delegate scrollPickerView:self didSelectButtonAtIndex:self.selectedIndex];
    }
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(self.buttonCount * self.buttonWidth, self.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)buttonBackgroudView {
    
    if (nil == _buttonBackgroudView) {
        _buttonBackgroudView = [[UIView alloc] init];
    }
    return _buttonBackgroudView;
}

- (UIView *)indexView {
    
    if (nil == _indexView) {
        _indexView = [[UIView alloc] init];
        _indexView.backgroundColor = kColor;
    }
    return _indexView;
}


@end
