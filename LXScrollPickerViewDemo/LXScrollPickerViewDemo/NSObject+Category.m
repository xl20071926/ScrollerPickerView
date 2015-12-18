//
//  NSObject+Category.m
//  LXScrollPickerViewDemo
//
//  Created by Leexin on 15/12/17.
//  Copyright © 2015年 Garden.Lee. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

- (BOOL)isNotEmptyNSString {
    
    if (self != nil && [self isKindOfClass:[NSString class]] && [(NSString *)self length] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmptyArray {
    
    if (self != nil && [self isKindOfClass:[NSArray class]] && [(NSArray *)self count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmptyDictionary {
    
    if (self != nil && [self isKindOfClass:[NSDictionary class]] && [(NSDictionary *)self count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmptyNSNumberOrNSString {
    
    if (self != nil && [self isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    else if (self != nil && [self isNotEmptyNSString]) {
        return YES;
    }
    return NO;
}



@end

