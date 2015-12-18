//
//  LXScrollPickerView.h
//  LXScrollPickerViewDemo
//
//  Created by Leexin on 15/12/17.
//  Copyright © 2015年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@class LXScrollPickerView;
@protocol LXScrollPickerViewDelegate <NSObject>

- (void)scrollPickerView:(LXScrollPickerView *)scrollPickerView didSelectButtonAtIndex:(NSInteger)index;

@end

@interface LXScrollPickerView : UIView

@property (nonatomic, assign) BOOL isNeedCycle; // 是否需要循环
@property (nonatomic, weak) id<LXScrollPickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)buttonTitleArray pageCount:(NSInteger)pageCount; // buttonTitleArray：数据源 pageCount：每页按钮个数
- (void)changeItemButtonFromCurrentToIndex:(NSInteger)index; // 跳转到当前按钮相隔的第N按钮 index: 1 后一位  -1 前一位

@end
