//
//  ViewController.m
//  LXScrollPickerViewDemo
//
//  Created by Leexin on 15/12/17.
//  Copyright © 2015年 Garden.Lee. All rights reserved.
//

#import "ViewController.h"
#import "LXScrollPickerView.h"

@interface ViewController () <LXScrollPickerViewDelegate>

@property (nonatomic, strong) LXScrollPickerView *scrollPickerView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr = @[@"Item-0", @"Item-1", @"Item-2", @"Item-3", @"Item-4", @"Item-5", @"Item-6", @"Item-7", @"Item-8", @"Item-9", @"Item-10", @"Item-11",@"Item-12",@"Item-13"];
    self.scrollPickerView = [[LXScrollPickerView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50.f) buttonTitleArray:arr pageCount:4];
    self.scrollPickerView.delegate = self;
    [self.view addSubview:self.scrollPickerView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70.f, SCREEN_WIDTH, 200.f)];
    self.label.font = [UIFont boldSystemFontOfSize:20.f];
    self.label.text = @"item-0";
    [self.view addSubview:self.label];
}

- (void)scrollPickerView:(LXScrollPickerView *)scrollPickerView didSelectButtonAtIndex:(NSInteger)index {
    
    self.label.text = [NSString stringWithFormat:@"item-%ld",index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
