//
//  NSArray+Category.m
//  LXScrollPickerViewDemo
//
//  Created by Leexin on 15/12/17.
//  Copyright © 2015年 Garden.Lee. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (id)safeObjectAtIndex:(NSUInteger)index {
    
    id obj = nil;
    if (index < self.count) {
        obj = [self objectAtIndex:index];
    }
    return obj;
}

@end
